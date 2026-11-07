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

  // Abre el reproductor mediante un Bottom Sheet.
  void _openPlayer(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,

      // Permite controlar la altura.
      isScrollControlled: true,
      // elimina la barra superior del Bottom Sheet
      showDragHandle: false,
      // Permite cerrarlo deslizando hacia abajo.
      enableDrag: true,
      // Fondo transparente fuera del reproductor.
      backgroundColor: Colors.transparent,
      // No agrega espacio superior adicional.
      useSafeArea: false,
      // Recorta el contenido en los bordes.
      clipBehavior: Clip.antiAlias,

      builder: (context) {
        return const FractionallySizedBox(
          // tamano que ocupa el reproductor de la pantalla
          heightFactor: 0.82,

          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            child: PlayerScreen(),
          ),
        );
      },
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
        toolbarHeight: 72,
        titleSpacing: 20,

        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              child: Image.asset(
                'assets/icons/iconRadio.png',
                width: 55,
                height: 55,
              ),
            ),

            const SizedBox(width: 2),

            Text(
              'Radio App',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 23,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),

      body: Consumer<AudioProvider>(
        builder: (context, audio, _) {
          final station = audio.station;
          final programs = DemoData.programsFor(station?.id);

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),

                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // PROGRAMAS DESTACADOS
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 26,
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              'Programas destacados',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        station == null
                            ? 'Explora los programas demo'
                            : 'De ${station.name}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          color: AppColors.surface.withValues(alpha: 0.80),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Carrusel
                      ProgramCarousel(programs: programs),

                      const SizedBox(height: 32),

                      Divider(
                        color: AppColors.surface.withValues(alpha: 0.12),
                        thickness: 1,
                      ),

                      const SizedBox(height: 28),

                      // ESTACIONES EN VIVO
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 26,
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              'Estaciones en vivo',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Selecciona una emisora para escucharla',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          color: AppColors.surface.withValues(alpha: 0.80),
                        ),
                      ),

                      // Mensaje de error
                      if (audio.errorMessage != null) ...[
                        const SizedBox(height: 8),

                        Text(
                          audio.errorMessage!,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ],

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // LISTA DE ESTACIONES
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),

                sliver: SliverList.builder(
                  itemCount: DemoData.stations.length,

                  itemBuilder: (context, index) {
                    final item = DemoData.stations[index];

                    return StationCard(
                      station: item,
                      isActive: item.id == station?.id,

                      // selección de estacion
                      onTap: () => unawaited(audio.selectStation(item)),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),

      // MINIPLAYER
      bottomNavigationBar: Consumer<AudioProvider>(
        builder: (context, audio, _) {
          final station = audio.station;

          if (station == null) {
            return const SizedBox.shrink();
          }

          return SafeArea(
            top: false,

            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),

              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color: AppColors.surface.withValues(alpha: 0.20),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),

                  child: MiniPlayer(
                    station: station,
                    phase: audio.phase,
                    onPlayPause: () => unawaited(audio.togglePlayback()),

                    // Abre el reproductor como Bottom Sheet.
                    onTap: () => _openPlayer(context),
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
