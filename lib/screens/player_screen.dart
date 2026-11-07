import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_app/app_theme.dart';
import 'package:radio_app/helpers/providers/audio_provider.dart';
import 'package:radio_app/models/station_model.dart';
import 'package:radio_app/services/app_service.dart';
import 'package:radio_app/widgets/playback_badge.dart';
import 'package:radio_app/widgets/station_artwork.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  static const Color _background = Color(0xFF202327);

  // Iconos originales de redes sociales.
  IconData _socialIcon(String platform) => switch (platform) {
    'facebook' => Icons.facebook,
    'instagram' => Icons.camera_alt_outlined,
    'x' => Icons.alternate_email,
    'bluesky' => Icons.cloud_outlined,
    'discord' => Icons.forum_outlined,
    _ => Icons.open_in_new,
  };

  Future<void> _openLink(BuildContext context, String url) async {
    final opened = await const AppService().openExternalLink(url);

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace externo.')),
      );
    }
  }

  Widget _links(BuildContext context, StationModel station) {
    final links = <MapEntry<String, String>>[
      if (station.websiteUrl != null)
        MapEntry('Sitio web', station.websiteUrl!),
      ...station.socialLinks.entries,
    ];

    if (links.isEmpty) {
      return const Text(
        'Esta estación no tiene enlaces registrados.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white70, fontSize: 12),
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 6,
      children: links.map((link) {
        return OutlinedButton.icon(
          onPressed: () => unawaited(_openLink(context, link.value)),
          icon: Icon(
            link.key == 'Sitio web' ? Icons.language : _socialIcon(link.key),
            size: 17,
          ),
          label: Text(
            link.key == 'Sitio web' ? link.key : link.key.toUpperCase(),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.white.withValues(alpha: 0.08),
            side: const BorderSide(color: Colors.white30),
            visualDensity: VisualDensity.compact,
            textStyle: const TextStyle(fontSize: 11),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Onda decorativa del reproductor.
  Widget _waveform() {
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
      height: 46,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < heights.length; i++)
              Container(
                width: 4,
                height: heights[i],
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: i < 18 ? 0.95 : 0.30),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,

      body: Consumer<AudioProvider>(
        builder: (context, audio, _) {
          final station = audio.station;

          if (station == null) {
            return const Center(
              child: Text(
                'Selecciona una estación desde Inicio.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final playing = audio.isPlaying;

          return SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Tamaño adaptable de la carátula.
                final artworkSize = math.min(
                  165.0,
                  constraints.maxWidth * 0.43,
                );

                final contentWidth = math.min(constraints.maxWidth - 32, 420.0);

                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),

                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            tooltip: 'Cerrar reproductor',
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),

                          const Expanded(
                            child: Text(
                              'Reproductor',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(width: 48),
                        ],
                      ),

                      Expanded(
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: SizedBox(
                              width: contentWidth,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.30,
                                          ),
                                          blurRadius: 18,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: StationArtwork(
                                      station: station,
                                      size: artworkSize,
                                      radius: 20,
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  Text(
                                    station.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    station.acronym,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.white70,
                                    ),
                                  ),

                                  const SizedBox(height: 7),

                                  Text(
                                    station.slogan,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      height: 1.4,
                                      color: Colors.white70,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // ESTADO DEL AUDIO
                                  PlaybackBadge(phase: audio.phase),

                                  // ERROR
                                  if (audio.errorMessage != null) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      audio.errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: AppColors.error,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: 18),

                                  // ONDA
                                  _waveform(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (audio.isLoading)
                            const SizedBox(
                              width: 58,
                              height: 58,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          else
                            IconButton.filled(
                              tooltip: playing ? 'Pausar' : 'Reproducir',
                              onPressed: () =>
                                  unawaited(audio.togglePlayback()),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: _background,
                                minimumSize: const Size(58, 58),
                              ),
                              iconSize: 30,
                              icon: Icon(
                                playing
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                              ),
                            ),

                          const SizedBox(width: 24),

                          IconButton.outlined(
                            tooltip: 'Detener',
                            onPressed: audio.isLoading
                                ? null
                                : () => unawaited(audio.stop()),
                            style: IconButton.styleFrom(
                              foregroundColor: Colors.white,
                              disabledForegroundColor: Colors.white38,
                              side: const BorderSide(color: Colors.white54),
                              minimumSize: const Size(52, 52),
                            ),
                            icon: const Icon(Icons.stop_rounded, size: 26),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // REDES SOCIALES
                      const Divider(color: Colors.white24),

                      const SizedBox(height: 8),

                      const Text(
                        'Redes sociales y enlaces',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ENLACES
                      _links(context, station),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
