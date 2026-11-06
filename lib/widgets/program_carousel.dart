import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:radio_app/app_theme.dart';
import 'package:radio_app/models/program_model.dart';
import 'package:radio_app/widgets/program_card.dart';

class ProgramCarousel extends StatelessWidget {
  final List<ProgramModel> programs;
  const ProgramCarousel({super.key, required this.programs});

  void _showDetails(BuildContext context, ProgramModel program) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.headphones, size: 68, color: AppColors.primary),
              const SizedBox(height: 14),
              Text(program.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Text(program.description, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 10),
              Text(program.schedule, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 18),
              Align(alignment: Alignment.centerRight,
                child: TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar'))),
            ])),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (programs.isEmpty) {
      return const SizedBox(height: 120,
        child: Center(child: Text('No hay programas para esta estación.')));
    }
    return LayoutBuilder(builder: (context, constraints) => CarouselSlider.builder(
      key: ValueKey(programs.map((p) => p.id).join('|')),
      itemCount: programs.length,
      options: CarouselOptions(
        height: 180,
        viewportFraction: programs.length == 1
            ? 1.0
            : constraints.maxWidth < 370 ? 0.85 : 0.70,
        enableInfiniteScroll: false,
        autoPlay: false,
        padEnds: false,
      ),
      itemBuilder: (context, index, realIndex) => ProgramCard(
        program: programs[index], onTap: () => _showDetails(context, programs[index])),
    ));
  }
}
