import 'package:flutter/material.dart';
import 'package:radio_app/app_theme.dart';
import 'package:radio_app/helpers/providers/audio_provider.dart';
import 'package:radio_app/models/station_model.dart';
import 'package:radio_app/widgets/station_artwork.dart';

// El padre suministra los datos y acciones.
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
    // Estados
    final loading = phase == PlaybackPhase.loading;
    final playing = phase == PlaybackPhase.playing;

    return Material(
      color: AppColors.backgroundPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE9EEF3), width: 1),
      ),

      clipBehavior: Clip.antiAlias,

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

          child: Row(
            children: [
              // IMAGEN ESTACIÓN
              StationArtwork(station: station, size: 52, radius: 12),

              const SizedBox(width: 12),

              // INFORMACIÓN DE LA ESTACIÓN
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      station.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Estado reproductor.
                    Text(
                      loading
                          ? 'Conectando…'
                          : playing
                          ? 'EN VIVO'
                          : 'Toca para abrir',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: playing
                            ? AppColors.accent
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              if (loading)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.accent,
                    ),
                  ),
                )
              else
                IconButton(
                  tooltip: playing ? 'Pausar' : 'Reproducir',
                  onPressed: onPlayPause,

                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFEDF5FF),
                    minimumSize: const Size(44, 44),
                  ),

                  icon: Icon(
                    playing
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: AppColors.accent,
                    size: 34,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
