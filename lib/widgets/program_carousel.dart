import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:radio_app/app_theme.dart';
import 'package:radio_app/models/program_model.dart';
import 'package:radio_app/widgets/program_card.dart';

class ProgramCarousel extends StatelessWidget {
  final List<ProgramModel> programs;

  const ProgramCarousel({super.key, required this.programs});

  // Ventana detalles del programa.
  void _showDetails(BuildContext context, ProgramModel program) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,

      backgroundColor: AppColors.backgroundPrimary,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),

      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.large),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 220,

                  child:
                      program.imageUrl != null && program.imageUrl!.isNotEmpty
                      ? Image.network(
                          program.imageUrl!,
                          fit: BoxFit.cover,

                          errorBuilder: (context, error, stackTrace) {
                            return const ColoredBox(
                              color: AppColors.background,
                              child: Icon(
                                Icons.headphones,
                                size: 70,
                                color: AppColors.accent,
                              ),
                            );
                          },
                        )
                      : const ColoredBox(
                          color: AppColors.background,
                          child: Icon(
                            Icons.headphones,
                            size: 70,
                            color: AppColors.accent,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                program.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                program.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  height: 1.5,
                  color: const Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: AppColors.accent,
                      size: 22,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        program.schedule,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // BOTON CERRAR
              Align(
                alignment: Alignment.centerRight,

                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    elevation: 0,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: const Text(
                    'Cerrar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (programs.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(child: Text('No hay programas para esta estación.')),
      );
    }

    // CARRUSEl
    return LayoutBuilder(
      builder: (context, constraints) {
        return CarouselSlider.builder(
          key: ValueKey(programs.map((p) => p.id).join('|')),

          itemCount: programs.length,

          options: CarouselOptions(
            height: 180,

            viewportFraction: programs.length == 1
                ? 1.0
                : constraints.maxWidth < 370
                ? 0.85
                : 0.70,

            enableInfiniteScroll: false,
            autoPlay: false,
            padEnds: false,
          ),

          itemBuilder: (context, index, realIndex) {
            return ProgramCard(
              program: programs[index],
              onTap: () => _showDetails(context, programs[index]),
            );
          },
        );
      },
    );
  }
}
