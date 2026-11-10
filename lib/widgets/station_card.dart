import 'package:flutter/material.dart';
import 'package:radio_app/app_theme.dart';
import 'package:radio_app/models/station_model.dart';
import 'package:radio_app/widgets/station_artwork.dart';

class StationCard extends StatelessWidget {
  final StationModel station;
  final bool isActive;
  final VoidCallback onTap;

  const StationCard({
    super.key,
    required this.station,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: isActive ? AppColors.accent : AppColors.border,
          width: isActive ? 1.5 : 1,
        ),
        boxShadow: AppShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Row(
              children: [
                StationArtwork(station: station, size: 76, radius: 15),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        station.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.stationTitle,
                      ),

                      const SizedBox(height: 5),

                      Text(
                        station.acronym.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.stationAcronym.copyWith(
                          color: isActive ? AppColors.accent : AppColors.muted,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        station.slogan,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.stationDescription,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.accent : AppColors.background,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isActive
                        ? Icons.graphic_eq_rounded
                        : Icons.play_arrow_rounded,
                    color: isActive ? Colors.white : AppColors.accent,
                    size: 23,
                    semanticLabel: isActive
                        ? 'Estación activa'
                        : 'Seleccionar estación',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
