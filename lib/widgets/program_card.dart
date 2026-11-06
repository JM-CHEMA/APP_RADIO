import 'package:flutter/material.dart';
import 'package:radio_app/app_theme.dart';
import 'package:radio_app/models/program_model.dart';

class ProgramCard extends StatelessWidget {
  final ProgramModel program;
  final VoidCallback onTap;

  const ProgramCard({super.key, required this.program, required this.onTap});

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(right: 8),
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.normal),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(width: 52, height: 52,
                child: program.imageUrl == null
                    ? const ColoredBox(color: AppColors.surfaceRaised,
                        child: Icon(Icons.headphones, color: AppColors.primary))
                    : Image.network(program.imageUrl!, fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => const ColoredBox(
                          color: AppColors.surfaceRaised,
                          child: Icon(Icons.headphones, color: AppColors.primary))),
              ),
            ),
            const Spacer(),
            const Icon(Icons.open_in_new, color: AppColors.textSecondary, size: 18),
          ]),
          const Spacer(),
          Text(program.title, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 5),
          Text(program.description, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall),
        ]),
      ),
    ),
  );
}
