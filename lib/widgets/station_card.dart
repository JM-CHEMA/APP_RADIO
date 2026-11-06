import 'package:flutter/material.dart';
import 'package:radio_app/app_theme.dart';
import 'package:radio_app/models/station_model.dart';
import 'package:radio_app/widgets/station_artwork.dart';

// Solo presenta información y transmite la selección al widget padre.
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
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: AppSpacing.medium),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: BorderSide(
        color: isActive ? AppColors.accent : Colors.transparent,
        width: isActive ? 2 : 0,
      ),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Row(children: [
          StationArtwork(station: station),
          const SizedBox(width: AppSpacing.medium),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(station.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium),
              Text(station.acronym, style: Theme.of(context).textTheme.bodySmall),
              Text(station.slogan, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium),
            ],
          )),
          if (isActive)
            const Icon(Icons.graphic_eq, color: AppColors.accent, semanticLabel: 'Estación activa')
          else
            const Icon(Icons.play_circle_outline, color: AppColors.primary),
        ]),
      ),
    ),
  );
}
