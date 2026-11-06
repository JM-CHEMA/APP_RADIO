import 'package:flutter/material.dart';
import 'package:radio_app/app_theme.dart';
import 'package:radio_app/helpers/providers/audio_provider.dart';
import 'package:radio_app/models/station_model.dart';
import 'package:radio_app/widgets/station_artwork.dart';

// El padre suministra los datos y acciones; este widget solo los presenta.
class MiniPlayer extends StatelessWidget {
  final StationModel station;
  final PlaybackPhase phase;
  final VoidCallback onPlayPause;
  final VoidCallback onTap;

  const MiniPlayer({
    super.key,
    required this.station,
    required this.phase,
    required this.onPlayPause,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final loading = phase == PlaybackPhase.loading;
    final playing = phase == PlaybackPhase.playing;
    return Material(
      color: AppColors.surfaceRaised,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Row(children: [
            StationArtwork(station: station, size: 46, radius: 10),
            const SizedBox(width: AppSpacing.medium),
            Expanded(child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(station.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium),
                Text(loading ? 'Conectando…' : playing ? 'EN VIVO' : 'Toca para abrir',
                  style: Theme.of(context).textTheme.bodySmall),
              ],
            )),
            if (loading)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 13),
                child: SizedBox(width: 24, height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2)),
              )
            else
              IconButton(
                tooltip: playing ? 'Pausar' : 'Reproducir',
                onPressed: onPlayPause,
                icon: Icon(playing ? Icons.pause_circle_filled : Icons.play_circle_fill,
                  color: AppColors.accent, size: 36),
              ),
          ]),
        ),
      ),
    );
  }
}
