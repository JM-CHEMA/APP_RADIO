import 'package:flutter/material.dart';
import 'package:radio_app/app_theme.dart';
import 'package:radio_app/helpers/providers/audio_provider.dart';

class PlaybackBadge extends StatelessWidget {
  final PlaybackPhase phase;
  const PlaybackBadge({super.key, required this.phase});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (phase) {
      PlaybackPhase.idle => ('SIN ESTACIÓN', AppColors.textSecondary),
      PlaybackPhase.loading => ('CONECTANDO', AppColors.primary),
      PlaybackPhase.playing => ('EN VIVO', AppColors.accent),
      PlaybackPhase.paused => ('PAUSADO', AppColors.primary),
      PlaybackPhase.stopped => ('DETENIDO', AppColors.textSecondary),
      PlaybackPhase.error => ('ERROR', AppColors.error),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.circle, size: 8, color: color),
        const SizedBox(width: 7),
        Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
      ]),
    );
  }
}
