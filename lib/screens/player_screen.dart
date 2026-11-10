import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_app/app_theme.dart';
import 'package:radio_app/helpers/constants.dart';
import 'package:radio_app/helpers/providers/audio_provider.dart';
import 'package:radio_app/models/station_model.dart';
import 'package:radio_app/services/app_service.dart';
import 'package:radio_app/widgets/playback_badge.dart';
import 'package:radio_app/widgets/station_artwork.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  Widget _stationBackground(StationModel station) {
    final imageUrl = station.imageUrl;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (imageUrl != null && imageUrl.isNotEmpty)
          ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const ColoredBox(color: AppColors.playerBackground);
              },
            ),
          ),

        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xB3101820), Color(0xCC101820), Color(0xF2101820)],
              stops: [0.0, 0.48, 1.0],
            ),
          ),
        ),
      ],
    );
  }

  IconData _socialIcon(String platform) {
    return switch (platform.toLowerCase()) {
      'facebook' => Icons.facebook,
      'instagram' => Icons.camera_alt_outlined,
      'x' => Icons.alternate_email,
      'bluesky' => Icons.cloud_outlined,
      'discord' => Icons.forum_outlined,
      _ => Icons.open_in_new_rounded,
    };
  }

  Future<void> _openLink(BuildContext context, String url) async {
    final opened = await const AppService().openExternalLink(url);

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace externo.')),
      );
    }
  }

  Future<void> _showStationSelector(BuildContext context) async {
    final audio = context.read<AudioProvider>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: false,
      backgroundColor: AppColors.playerSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.bottomSheet),
        ),
      ),
      builder: (sheetContext) {
        return SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height * 0.62,
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.medium),

                Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                const SizedBox(height: 22),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Cambiar estación',
                          style: AppTextStyles.playerTitle.copyWith(
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0,
                          ),
                        ),
                      ),

                      IconButton(
                        tooltip: 'Cerrar',
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.playerText,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.small),

                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: DemoData.stations.length,
                    separatorBuilder: (_, _) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      final station = DemoData.stations[index];
                      final selected = audio.station?.id == station.id;

                      return Material(
                        color: selected
                            ? AppColors.accent.withValues(alpha: 0.14)
                            : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(18),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Navigator.of(sheetContext).pop();

                            if (!selected) {
                              unawaited(audio.selectStation(station));
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.medium),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: selected
                                    ? AppColors.accent
                                    : Colors.white12,
                              ),
                            ),
                            child: Row(
                              children: [
                                StationArtwork(
                                  station: station,
                                  size: 56,
                                  radius: AppRadius.small,
                                ),

                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        station.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles.stationTitle
                                            .copyWith(
                                              fontSize: 14,
                                              color: AppColors.playerText,
                                            ),
                                      ),

                                      const SizedBox(height: 5),

                                      Text(
                                        station.slogan,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles.stationDescription
                                            .copyWith(
                                              color: AppColors.playerMuted,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: AppSpacing.small),

                                Icon(
                                  selected
                                      ? Icons.check_circle_rounded
                                      : Icons.chevron_right_rounded,
                                  color: selected
                                      ? AppColors.accent
                                      : AppColors.playerMuted,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _waveform(bool playing) {
    const heights = <double>[
      12,
      22,
      32,
      18,
      38,
      28,
      14,
      35,
      42,
      24,
      16,
      30,
      22,
      12,
      38,
      44,
      20,
      14,
      28,
      36,
      24,
      16,
      34,
      40,
      22,
      12,
      26,
      36,
    ];

    return SizedBox(
      height: 48,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < heights.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 3.5,
                height: heights[i],
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: playing
                      ? (i < 18
                            ? AppColors.playerText
                            : AppColors.playerMuted.withValues(alpha: 0.45))
                      : AppColors.playerMuted.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _links(BuildContext context, StationModel station) {
    final links = <MapEntry<String, String>>[
      if (station.websiteUrl != null && station.websiteUrl!.isNotEmpty)
        MapEntry('Sitio web', station.websiteUrl!),
      ...station.socialLinks.entries,
    ];

    if (links.isEmpty) {
      return Text(
        'Esta estación no tiene enlaces registrados.',
        textAlign: TextAlign.center,
        style: AppTextStyles.stationDescription.copyWith(
          color: AppColors.playerMuted,
        ),
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.small,
      runSpacing: AppSpacing.small,
      children: links.map((link) {
        return OutlinedButton.icon(
          onPressed: () {
            unawaited(_openLink(context, link.value));
          },
          icon: Icon(
            link.key == 'Sitio web'
                ? Icons.language_rounded
                : _socialIcon(link.key),
            size: 17,
          ),
          label: Text(
            link.key == 'Sitio web' ? 'Sitio web' : link.key.toUpperCase(),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.playerText,
            backgroundColor: Colors.white.withValues(alpha: 0.06),
            side: const BorderSide(color: Colors.white24),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.medium,
              vertical: 9,
            ),
            minimumSize: const Size(0, 36),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            textStyle: AppTextStyles.miniPlayerStatus,
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.playerBackground,
      body: Consumer<AudioProvider>(
        builder: (context, audio, _) {
          final station = audio.station;

          if (station == null) {
            return Center(
              child: Text(
                'Selecciona una estación desde Inicio.',
                textAlign: TextAlign.center,
                style: AppTextStyles.playerSubtitle.copyWith(
                  color: AppColors.playerText,
                  fontSize: 15,
                ),
              ),
            );
          }

          final playing = audio.isPlaying;

          return Stack(
            fit: StackFit.expand,
            children: [
              _stationBackground(station),

              SafeArea(
                top: true,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                      child: Row(
                        children: [
                          IconButton(
                            tooltip: 'Cerrar reproductor',
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.playerText,
                              size: 30,
                            ),
                          ),

                          Expanded(
                            child: Text(
                              'REPRODUCTOR',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.playerSectionLabel.copyWith(
                                fontSize: 11,
                                letterSpacing: 2,
                              ),
                            ),
                          ),

                          const SizedBox(width: 48),
                        ],
                      ),
                    ),

                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, viewport) {
                          final compact = viewport.maxHeight < 600;

                          final artworkSize = math.min(
                            compact ? 155.0 : 218.0,
                            viewport.maxWidth * 0.54,
                          );

                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: math.max(
                                  0.0,
                                  viewport.maxHeight - 28,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.artwork,
                                      ),
                                      boxShadow: AppShadows.artwork,
                                    ),
                                    child: StationArtwork(
                                      station: station,
                                      size: artworkSize,
                                      radius: AppRadius.artwork,
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  Text(
                                    station.name,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.playerTitle,
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    station.acronym,
                                    style: AppTextStyles.stationAcronym
                                        .copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.5,
                                          color: AppColors.accent,
                                        ),
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    station.slogan,
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.playerSubtitle,
                                  ),

                                  const SizedBox(height: AppSpacing.normal),

                                  PlaybackBadge(phase: audio.phase),

                                  if (audio.errorMessage != null) ...[
                                    const SizedBox(height: 10),

                                    Text(
                                      audio.errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.stationDescription
                                          .copyWith(color: AppColors.error),
                                    ),
                                  ],

                                  const SizedBox(height: AppSpacing.large),

                                  _waveform(playing),

                                  const SizedBox(height: AppSpacing.large),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (audio.isLoading)
                                        const SizedBox(
                                          width: 64,
                                          height: 64,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.accent,
                                            ),
                                          ),
                                        )
                                      else
                                        IconButton.filled(
                                          tooltip: playing
                                              ? 'Pausar'
                                              : 'Reproducir',
                                          onPressed: () {
                                            unawaited(audio.togglePlayback());
                                          },
                                          style: IconButton.styleFrom(
                                            backgroundColor:
                                                AppColors.playerText,
                                            foregroundColor:
                                                AppColors.playerBackground,
                                            minimumSize: const Size(64, 64),
                                          ),
                                          iconSize: 34,
                                          icon: Icon(
                                            playing
                                                ? Icons.pause_rounded
                                                : Icons.play_arrow_rounded,
                                          ),
                                        ),

                                      const SizedBox(width: AppSpacing.large),

                                      IconButton.outlined(
                                        tooltip: 'Cambiar estación',
                                        onPressed: () {
                                          unawaited(
                                            _showStationSelector(context),
                                          );
                                        },
                                        style: IconButton.styleFrom(
                                          foregroundColor: AppColors.playerText,
                                          side: const BorderSide(
                                            color: Colors.white38,
                                          ),
                                          minimumSize: const Size(54, 54),
                                        ),
                                        icon: const Icon(
                                          Icons.swap_horiz_rounded,
                                          size: 27,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 28),

                                  const Divider(color: Colors.white12),

                                  const SizedBox(height: 18),

                                  Text(
                                    'REDES SOCIALES Y ENLACES',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.playerSectionLabel,
                                  ),

                                  const SizedBox(height: 14),

                                  _links(context, station),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
