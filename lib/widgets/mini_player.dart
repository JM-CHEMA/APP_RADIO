import 'package:flutter/material.dart';
import 'package:radio_app/app_theme.dart';
import 'package:radio_app/helpers/providers/audio_provider.dart';
import 'package:radio_app/models/station_model.dart';
import 'package:radio_app/widgets/station_artwork.dart';

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
      color: AppColors.backgroundPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: AppSpacing.medium,
          ),
          child: Row(
            children: [
              StationArtwork(
                station: station,
                size: 56,
                radius: AppRadius.medium,
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.miniPlayerTitle,
                    ),

                    const SizedBox(height: 6),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (playing) ...[
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                          ),

                          const SizedBox(width: 7),
                        ],

                        Flexible(
                          child: Text(
                            loading
                                ? 'Conectando…'
                                : playing
                                ? 'EN VIVO'
                                : 'Toca para abrir',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.miniPlayerStatus.copyWith(
                              letterSpacing: playing ? 0.6 : 0,
                              color: playing
                                  ? AppColors.accent
                                  : AppColors.muted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              if (loading)
                const SizedBox(
                  width: 46,
                  height: 46,
                  child: Center(
                    child: SizedBox(
                      width: 23,
                      height: 23,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                )
              else
                IconButton.filled(
                  tooltip: playing ? 'Pausar' : 'Reproducir',
                  onPressed: onPlayPause,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(46, 46),
                    padding: EdgeInsets.zero,
                    shape: const CircleBorder(),
                  ),
                  iconSize: 28,
                  icon: Icon(
                    playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
