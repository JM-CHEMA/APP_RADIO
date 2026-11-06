import 'dart:async';

import 'package:audio_service/audio_service.dart' as bg;
import 'package:flutter/foundation.dart';
import 'package:radio_app/helpers/constants.dart';
import 'package:radio_app/models/station_model.dart';
import 'package:radio_app/services/audio_service.dart';

enum PlaybackPhase { idle, loading, playing, paused, stopped, error }

// Fuente de verdad compartida por HomeScreen, MiniPlayer y PlayerScreen.
// Aquí no se crean AudioPlayers: el motor de audio vive en RadioAudioService.
class AudioProvider extends ChangeNotifier {
  final RadioAudioService _service;
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  StationModel? _station;
  PlaybackPhase _phase = PlaybackPhase.idle;
  String? _errorMessage;
  bool _busySelection = false;
  int _selectionToken = 0;

  AudioProvider(this._service) {
    _subscriptions.add(
      _service.mediaItem.listen((item) {
        if (item == null) return;
        final station = DemoData.stationById(item.id);
        if (station != null && station.id != _station?.id) {
          _station = station;
          notifyListeners();
        }
      }),
    );
    _subscriptions.add(_service.playbackState.listen(_onPlaybackState));
  }

  StationModel? get station => _station;
  PlaybackPhase get phase => _phase;
  String? get errorMessage => _errorMessage;
  bool get isPlaying => _phase == PlaybackPhase.playing;
  bool get isLoading => _phase == PlaybackPhase.loading;

  void _setPhase(PlaybackPhase next) {
    if (_phase == next) return;
    _phase = next;
    notifyListeners();
  }

  void _onPlaybackState(bg.PlaybackState state) {
    if (state.processingState == bg.AudioProcessingState.error) {
      _busySelection = false;
      _errorMessage =
          _service.lastError ?? 'No fue posible conectar con la estación.';
      _setPhase(PlaybackPhase.error);
      return;
    }
    if (_busySelection) return;
    // Conserva el error visible si stop() es consecuencia de un fallo de red.
    if (_phase == PlaybackPhase.error &&
        _errorMessage != null &&
        state.processingState == bg.AudioProcessingState.idle) {
      return;
    }
    if (_station == null) {
      _setPhase(PlaybackPhase.idle);
      return;
    }
    final next = switch (state.processingState) {
      bg.AudioProcessingState.loading ||
      bg.AudioProcessingState.buffering => PlaybackPhase.loading,
      bg.AudioProcessingState.ready =>
        state.playing ? PlaybackPhase.playing : PlaybackPhase.paused,
      bg.AudioProcessingState.idle ||
      bg.AudioProcessingState.completed => PlaybackPhase.stopped,
      bg.AudioProcessingState.error => PlaybackPhase.error,
    };
    _setPhase(next);
  }

  Future<void> selectStation(StationModel station) async {
    final token = ++_selectionToken;
    _station = station;
    _busySelection = true;
    _errorMessage = null;
    _setPhase(PlaybackPhase.loading);
    try {
      await _service.selectStation(station);
      if (token != _selectionToken) return;
      _busySelection = false;
      _onPlaybackState(_service.playbackState.value);
    } catch (error) {
      if (token != _selectionToken) return;
      _busySelection = false;
      _errorMessage = error.toString();
      _setPhase(PlaybackPhase.error);
    }
  }

  Future<void> togglePlayback() async {
    if (_station == null || isLoading) return;
    try {
      if (isPlaying) {
        await _service.pause();
      } else if (_phase == PlaybackPhase.stopped ||
          _phase == PlaybackPhase.error) {
        await selectStation(_station!);
      } else {
        await _service.play();
      }
    } catch (error) {
      _errorMessage = error.toString();
      _setPhase(PlaybackPhase.error);
    }
  }

  Future<void> stop() async {
    if (_station == null) return;
    ++_selectionToken;
    _busySelection = false;
    try {
      await _service.stop();
      _setPhase(PlaybackPhase.stopped);
    } catch (error) {
      _errorMessage = error.toString();
      _setPhase(PlaybackPhase.error);
    }
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    // No se destruye el audio al liberar una pantalla: lo gestiona el servicio.
    super.dispose();
  }
}
