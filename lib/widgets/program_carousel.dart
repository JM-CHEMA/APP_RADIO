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
      useSafeArea: true,
      isDismissible: true,
      enableDrag: true,
      showDragHandle: true,
      backgroundColor: AppColors.backgroundPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.bottomSheet),
        ),
      ),
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DETALLES DEL PROGRAMA',
                    style: AppTextStyles.stationAcronym,
                  ),

                  const SizedBox(height: AppSpacing.large),

                  Center(
                    child: Container(
                      width: 210,
                      height: 210,
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
                                  return const ColoredBox(
                                    color: AppColors.background,
                                    child: Icon(
                                      Icons.headphones_rounded,
                                      size: 64,
                                      color: AppColors.accent,
                                    ),
                                  );
                                },
                              )
                            : const ColoredBox(
                                color: AppColors.background,
                                child: Icon(
                                  Icons.headphones_rounded,
                                  size: 64,
                                  color: AppColors.accent,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.large),

                  Text(
                    program.title,
                    style: AppTextStyles.sectionTitle.copyWith(fontSize: 25),
                  ),

                  const SizedBox(height: AppSpacing.medium),

                  Text(
                    program.description,
                    style: AppTextStyles.sectionSubtitle.copyWith(
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.large),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.normal),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(AppRadius.normal),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          color: AppColors.accent,
                          size: 22,
                        ),

                        const SizedBox(width: AppSpacing.medium),

                        Expanded(
                          child: Text(
                            program.schedule,
                            style: AppTextStyles.sectionSubtitle.copyWith(
                              fontSize: 14,
                              color: AppColors.subtitle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportFraction = constraints.maxWidth < 360 ? 0.46 : 0.42;

        final itemWidth = constraints.maxWidth * viewportFraction;

        final carouselHeight = (itemWidth - AppSpacing.medium + 62).clamp(
          180.0,
          290.0,
        );

        if (programs.length == 1) {
          return SizedBox(
            height: carouselHeight,
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: itemWidth,
                height: carouselHeight,
                child: ProgramCard(
                  program: programs.first,
                  onTap: () => _showDetails(context, programs.first),
                ),
              ),
            ),
          );
        }

        return CarouselSlider.builder(
          key: ValueKey(programs.map((program) => program.id).join('|')),
          itemCount: programs.length,
          options: CarouselOptions(
            height: carouselHeight,
            viewportFraction: viewportFraction,
            enableInfiniteScroll: false,
            autoPlay: false,
            padEnds: false,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
          ),
          itemBuilder: (context, index, realIndex) {
            final program = programs[index];

            return ProgramCard(
              program: program,
              onTap: () => _showDetails(context, program),
            );
          },
        );
      },
    );
  }
}
