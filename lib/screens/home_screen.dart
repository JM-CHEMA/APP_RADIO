import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_app/app_theme.dart';
import 'package:radio_app/helpers/constants.dart';
import 'package:radio_app/helpers/providers/audio_provider.dart';
import 'package:radio_app/screens/player_screen.dart';
import 'package:radio_app/widgets/mini_player.dart';
import 'package:radio_app/widgets/program_carousel.dart';
import 'package:radio_app/widgets/station_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openPlayer(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      clipBehavior: Clip.antiAlias,
      builder: (context) {
        return const FractionallySizedBox(
          heightFactor: 1.0,
          child: PlayerScreen(),
        );
      },
    );
  }

  Widget _sectionHeader({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.sectionTitle),

        const SizedBox(height: 7),

        Text(subtitle, style: AppTextStyles.sectionSubtitle),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,

      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        surfaceTintColor: AppColors.backgroundPrimary,
        elevation: 0,
        toolbarHeight: 76,
        titleSpacing: 20,

        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/iconRadio.png',
              width: 48,
              height: 48,
              fit: BoxFit.contain,
            ),

            const SizedBox(width: 10),

            Text('Radio App', style: AppTextStyles.appTitle),
          ],
        ),
      ),

      body: Consumer<AudioProvider>(
        builder: (context, audio, _) {
          final station = audio.station;

          final programs = DemoData.stations
              .expand((item) => DemoData.programsFor(item.id))
              .toList();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),

            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),

                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(
                            title: 'Programas destacados',
                            subtitle: station == null
                                ? 'Explora los programas demo'
                                : 'De ${station.name}',
                          ),

                          const SizedBox(height: 22),

                          ProgramCarousel(programs: programs),

                          const SizedBox(height: AppSpacing.section),

                          _sectionHeader(
                            title: 'Estaciones en vivo',
                            subtitle: 'Selecciona una emisora para escucharla',
                          ),

                          if (audio.errorMessage != null) ...[
                            const SizedBox(height: 14),

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(
                                AppSpacing.medium + 2,
                              ),

                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.medium,
                                ),
                              ),

                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline_rounded,
                                    color: AppColors.error,
                                    size: 20,
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: Text(
                                      audio.errorMessage!,
                                      style: AppTextStyles.stationDescription
                                          .copyWith(
                                            color: const Color(0xFFB93B47),
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 22),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.only(bottom: AppSpacing.large),

                sliver: SliverList.builder(
                  itemCount: DemoData.stations.length,

                  itemBuilder: (context, index) {
                    final item = DemoData.stations[index];

                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),

                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),

                          child: StationCard(
                            station: item,
                            isActive: item.id == station?.id,
                            onTap: () => unawaited(audio.selectStation(item)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),

      bottomNavigationBar: Consumer<AudioProvider>(
        builder: (context, audio, _) {
          final station = audio.station;

          if (station == null) {
            return const SizedBox.shrink();
          }

          return SafeArea(
            top: false,

            child: Center(
              heightFactor: 1,

              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),

                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.normal,
                    AppSpacing.small,
                    AppSpacing.normal,
                    AppSpacing.medium,
                  ),

                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      boxShadow: AppShadows.miniPlayer,
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.card),

                      child: MiniPlayer(
                        station: station,
                        phase: audio.phase,

                        onPlayPause: () => unawaited(audio.togglePlayback()),

                        onTap: () => _openPlayer(context),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
