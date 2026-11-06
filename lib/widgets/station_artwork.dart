import 'package:flutter/material.dart';
import 'package:radio_app/app_theme.dart';
import 'package:radio_app/models/station_model.dart';

// Una sola representación de carátulas para tarjetas, MiniPlayer y FullPlayer.
class StationArtwork extends StatelessWidget {
  final StationModel station;
  final double size;
  final double radius;

  const StationArtwork({super.key, required this.station, this.size = 58, this.radius = 14});

  @override
  Widget build(BuildContext context) {
    final url = station.imageUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: size, height: size,
        child: url == null || url.isEmpty
            ? _fallback()
            : Image.network(url, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _fallback()),
      ),
    );
  }

  Widget _fallback() => ColoredBox(
    color: AppColors.surfaceRaised,
    child: Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.graphic_eq, color: AppColors.primary),
        Text(station.acronym, style: const TextStyle(
          fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
      ]),
    ),
  );
}
