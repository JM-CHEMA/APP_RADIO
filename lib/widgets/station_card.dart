import 'package:flutter/material.dart';
import 'package:radio_app/app_theme.dart';
import 'package:radio_app/models/station_model.dart';
import 'package:radio_app/widgets/station_artwork.dart';

//informacion de estacion.
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
    return Card(
      color: AppColors.backgroundPrimary,
      surfaceTintColor: Colors.transparent,
      margin: const EdgeInsets.only(bottom: AppSpacing.medium),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isActive ? AppColors.accent : const Color(0xFFE8EDF2),
          width: isActive ? 1.5 : 1,
        ),
      ),

      clipBehavior: Clip.antiAlias,

      child: InkWell(
        onTap: onTap,

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: StationArtwork(station: station, size: 72, radius: 14),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      station.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      station.acronym,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      station.slogan,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Container(
                width: 36,
                height: 36,

                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),

                child: Icon(
                  isActive ? Icons.graphic_eq : Icons.play_circle_outline,
                  color: AppColors.accent,
                  size: 22,
                  semanticLabel: isActive
                      ? 'Estación activa'
                      : 'Seleccionar estación',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
