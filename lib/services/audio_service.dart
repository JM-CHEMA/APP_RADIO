import 'dart:async';

import 'package:audio_service/audio_service.dart' as bg;
import 'package:just_audio/just_audio.dart' as ja;
import 'package:radio_app/helpers/constants.dart';
import 'package:radio_app/models/station_model.dart';

// Un único AudioPlayer para toda la app, incluso cuando la UI no está visible.
// El nombre RadioAudioService evita colisionar con AudioService del plugin.
class RadioAudioService extends bg.BaseAudioHandler {
  final ja.AudioPlayer _player = ja.AudioPlayer();
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  StationModel? _selectedStation;
  String? lastError;
  int _latestRequest = 0;
  Future<void> _switchTail = Future<void>.value();

  RadioAudioService() {
    _subscriptions.add(
      _player.playerStateStream.listen((_) => _publishState()),
    );
    _subscriptions.add(
      _player.playbackEventStream.listen(
        (_) => _publishState(),
        onError: (Object error, StackTrace stackTrace) => _reportError(error),
      ),
    );
    _subscriptions.add(
      _player.errorStream.listen((error) => _reportError(error)),
    );
    _publishState();
  }

  StationModel? get selectedStation => _selectedStation;

  bg.AudioProcessingState _processingState(ja.ProcessingState state) {
    return switch (state) {
      ja.ProcessingState.idle => bg.AudioProcessingState.idle,
      ja.ProcessingState.loading => bg.AudioProcessingState.loading,
      ja.ProcessingState.buffering => bg.AudioProcessingState.buffering,
      ja.ProcessingState.ready => bg.AudioProcessingState.ready,
      ja.ProcessingState.completed => bg.AudioProcessingState.completed,
    };
  }

  void _publishState() {
    final stationAvailable = _selectedStation != null;
    final controls = <bg.MediaControl>[
      if (stationAvailable)
        _player.playing ? bg.MediaControl.pause : bg.MediaControl.play,
      if (stationAvailable) bg.MediaControl.stop,
    ];
    playbackState.add(
      bg.PlaybackState(
        controls: controls,
        androidCompactActionIndices: stationAvailable ? const [0, 1] : const [],
        processingState: _processingState(_player.processingState),
        playing: _player.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      ),
    );
  }

  void _reportError(Object error) {
    lastError = error.toString();
    playbackState.add(
      playbackState.value.copyWith(
        processingState: bg.AudioProcessingState.error,
        playing: false,
      ),
    );
  }

  // Las solicitudes se serializan: nunca habrá dos streams reproduciéndose.
  // Cuando llega otra selección, se omiten las solicitudes anteriores pendientes.
  Future<void> selectStation(StationModel station) {
    final request = ++_latestRequest;
    final operation = _switchTail.then((_) async {
      if (request != _latestRequest) return;
      lastError = null;
      await _player.stop();
      if (request != _latestRequest) return;

      _selectedStation = station;
      mediaItem.add(
        bg.MediaItem(
          id: station.id,
          album: 'Radio en vivo',
          title: station.name,
          artist: '${station.acronym} · ${station.slogan}',
          artUri: station.imageUrl == null
              ? null
              : Uri.tryParse(station.imageUrl!),
        ),
      );
      playbackState.add(
        playbackState.value.copyWith(
          processingState: bg.AudioProcessingState.loading,
          playing: false,
        ),
      );
      try {
        await _player
            .setUrl(station.streamUrl)
            .timeout(const Duration(seconds: 20));
        if (request != _latestRequest) return;
        // En radios en vivo, esperar el Future de play() puede no terminar nunca.
        unawaited(
          _player.play().catchError((Object error) {
            _reportError(error);
          }),
        );
      } catch (error) {
        if (request == _latestRequest) {
          await _player.stop();
          _reportError(error);
        }
        rethrow;
      }
    });
    // El siguiente cambio puede continuar incluso si el anterior falló.
    _switchTail = operation.then(
      (_) {},
      onError: (Object error, StackTrace stack) {},
    );
    return operation;
  }

  @override
  Future<void> playMediaItem(bg.MediaItem mediaItem) async {
    final station = DemoData.stationById(mediaItem.id);

    if (station != null) {
      await selectStation(station);
    }
  }

  @override
  Future<void> play() async {
    if (_selectedStation == null) return;
    if (_player.processingState == ja.ProcessingState.idle ||
        _player.processingState == ja.ProcessingState.completed) {
      await selectStation(_selectedStation!);
      return;
    }
    unawaited(
      _player.play().catchError((Object error) {
        _reportError(error);
      }),
    );
  }

  @override
  Future<void> pause() async => _player.pause();

  @override
  Future<void> stop() async {
    ++_latestRequest;
    await _player.stop();
    _publishState();
  }

  // Se llama cuando el servicio deja de utilizarse definitivamente; NO al
  // cerrar PlayerScreen, porque eso interrumpiría el segundo plano.
  Future<void> disposeResources() async {
    ++_latestRequest;
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    await _player.dispose();
  }
}
