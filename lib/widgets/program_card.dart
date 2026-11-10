import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:radio_app/app_theme.dart';
import 'package:radio_app/models/program_model.dart';

class ProgramCard extends StatelessWidget {
  final ProgramModel program;
  final VoidCallback onTap;

  const ProgramCard({super.key, required this.program, required this.onTap});

  Widget _fallbackImage() {
    return const ColoredBox(
      color: Color(0xFF243B53),
      child: Center(
        child: Icon(Icons.headphones_rounded, size: 52, color: Colors.white70),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageSize = math.min(
          constraints.maxWidth - AppSpacing.medium,
          math.max(0.0, constraints.maxHeight - 62),
        );

        return Padding(
          padding: const EdgeInsets.only(right: AppSpacing.medium),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: imageSize,
                    height: imageSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      boxShadow: AppShadows.program,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      child:
                          program.imageUrl != null &&
                              program.imageUrl!.isNotEmpty
                          ? Image.network(
                              program.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _fallbackImage();
                              },
                            )
                          : _fallbackImage(),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.small),

                  Text(
                    program.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.stationTitle.copyWith(fontSize: 14),
                  ),

                  const SizedBox(height: AppSpacing.extraSmall),

                  Text(
                    program.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.stationDescription,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
