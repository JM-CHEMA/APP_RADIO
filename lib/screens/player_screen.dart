import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_app/app_theme.dart';
import 'package:radio_app/helpers/providers/audio_provider.dart';
import 'package:radio_app/models/station_model.dart';
import 'package:radio_app/services/app_service.dart';
import 'package:radio_app/widgets/playback_badge.dart';
import 'package:radio_app/widgets/station_artwork.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  IconData _socialIcon(String platform) => switch (platform) {
    'facebook' => Icons.facebook,
    'instagram' => Icons.camera_alt_outlined,
    'x' => Icons.alternate_email,
    'bluesky' => Icons.cloud_outlined,
    'discord' => Icons.forum_outlined,
    _ => Icons.open_in_new,
  };

  Future<void> _openLink(BuildContext context, String url) async {
    final opened = await const AppService().openExternalLink(url);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No se pudo abrir el enlace externo.'),
      ));
    }
  }

  Widget _links(BuildContext context, StationModel station) {
    final links = <MapEntry<String, String>>[
      if (station.websiteUrl != null)
        MapEntry('Sitio web', station.websiteUrl!),
      ...station.socialLinks.entries,
    ];
    if (links.isEmpty) return const Text('Esta estación no tiene enlaces registrados.');
    return Wrap(alignment: WrapAlignment.center, spacing: 12, runSpacing: 8,
      children: links.map((link) => OutlinedButton.icon(
        onPressed: () => unawaited(_openLink(context, link.value)),
        icon: Icon(link.key == 'Sitio web' ? Icons.language : _socialIcon(link.key)),
        label: Text(link.key == 'Sitio web' ? link.key : link.key.toUpperCase()),
      )).toList(),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Reproductor')),
    body: Consumer<AudioProvider>(builder: (context, audio, _) {
      final station = audio.station;
      if (station == null) {
        return const Center(child: Text('Selecciona una estación desde Inicio.'));
      }
      final artworkSize = math.min(MediaQuery.sizeOf(context).width - 64, 250.0);
      final playing = audio.isPlaying;
      return SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Center(child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(children: [
            StationArtwork(station: station, size: artworkSize, radius: 24),
            const SizedBox(height: AppSpacing.large),
            Text(station.name, textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 6),
            Text(station.acronym, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(station.slogan, textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 18),
            PlaybackBadge(phase: audio.phase),
            if (audio.errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(audio.errorMessage!, textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.error)),
            ],
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (audio.isLoading)
                const SizedBox(width: 65, height: 65,
                  child: Center(child: CircularProgressIndicator()))
              else
                IconButton.filled(
                  tooltip: playing ? 'Pausar' : 'Reproducir',
                  onPressed: () => unawaited(audio.togglePlayback()),
                  iconSize: 42,
                  icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                ),
              const SizedBox(width: 20),
              IconButton.outlined(
                tooltip: 'Detener',
                onPressed: audio.isLoading ? null : () => unawaited(audio.stop()),
                iconSize: 36,
                icon: const Icon(Icons.stop),
              ),
            ]),
            const SizedBox(height: 26),
            const Divider(),
            const SizedBox(height: 12),
            Text('Redes sociales y enlaces', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 14),
            _links(context, station),
          ]),
        )),
      ));
    }),
  );
}
