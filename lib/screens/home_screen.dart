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

  void _openPlayer(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (context) => const PlayerScreen()),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Row(children: [
        Icon(Icons.radio, color: AppColors.primary),
        SizedBox(width: 10),
        Text('Radio App'),
      ]),
    ),
    body: Consumer<AudioProvider>(builder: (context, audio, _) {
      final station = audio.station;
      final programs = DemoData.programsFor(station?.id);
      return CustomScrollView(slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          sliver: SliverToBoxAdapter(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Programas destacados', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(station == null ? 'Explora los programas demo' : 'De ${station.name}',
                style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.medium),
              ProgramCarousel(programs: programs),
              const SizedBox(height: AppSpacing.large),
              Text('Estaciones en vivo', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text('Selecciona una emisora para escucharla',
                style: Theme.of(context).textTheme.bodyMedium),
              if (audio.errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(audio.errorMessage!, style: const TextStyle(color: AppColors.error)),
              ],
              const SizedBox(height: AppSpacing.medium),
            ],
          )),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverList.builder(
            itemCount: DemoData.stations.length,
            itemBuilder: (context, index) {
              final item = DemoData.stations[index];
              return StationCard(
                station: item,
                isActive: item.id == station?.id,
                onTap: () => unawaited(audio.selectStation(item)),
              );
            },
          ),
        ),
      ]);
    }),
    bottomNavigationBar: Consumer<AudioProvider>(builder: (context, audio, _) {
      final station = audio.station;
      if (station == null) return const SizedBox.shrink();
      return SafeArea(top: false, child: MiniPlayer(
        station: station,
        phase: audio.phase,
        onPlayPause: () => unawaited(audio.togglePlayback()),
        onTap: () => _openPlayer(context),
      ));
    }),
  );
}
