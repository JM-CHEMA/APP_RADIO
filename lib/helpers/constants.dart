import 'package:radio_app/models/program_model.dart';
import 'package:radio_app/models/station_model.dart';

// Catálogo de estaciones y programas de demostración.
abstract final class DemoData {
  // Estaciones de radio disponibles.
  static const stations = <StationModel>[
    StationModel(
      id: 'gsl',
      name: 'Groove Salad',
      acronym: 'GSL',
      slogan: 'Un plato frío de beats ambientales',
      streamUrl: 'https://ice5.somafm.com/groovesalad-128-mp3',
      imageUrl: 'https://somafm.com/img/GrooveSaladBox.jpg',
      websiteUrl: 'https://somafm.com/groovesalad',
      socialLinks: {'bluesky': 'https://bsky.app/profile/somafm.com'},
    ),

    StationModel(
      id: 'sag',
      name: 'Secret Agent',
      acronym: 'SAG',
      slogan: 'La banda sonora para tu vida elegante',
      streamUrl: 'https://ice5.somafm.com/secretagent-128-mp3',
      imageUrl: 'https://somafm.com/img/SecretAgentBox.jpg',
      websiteUrl: 'https://somafm.com/secretagent',
      socialLinks: {'bluesky': 'https://bsky.app/profile/somafm.com'},
    ),

    StationModel(
      id: 'ipr',
      name: 'Indie Pop Rocks!',
      acronym: 'IPR',
      slogan: 'Canciones indie pop nuevas y clásicas',
      streamUrl: 'https://ice5.somafm.com/indiepop-128-mp3',
      imageUrl: 'https://somafm.com/img/indychick.jpg',
      websiteUrl: 'https://somafm.com/indiepop',
      socialLinks: {'bluesky': 'https://bsky.app/profile/somafm.com'},
    ),

    StationModel(
      id: 'nrfm',
      name: 'Nightride FM',
      acronym: 'NRFM',
      slogan: 'Synthwave y Cyberpunk 24/7',
      streamUrl: 'https://stream.nightride.fm/nightride.mp3',
      websiteUrl: 'https://nightride.fm/',
      socialLinks: {
        'instagram': 'https://www.instagram.com/fmnightride/',
        'x': 'https://twitter.com/nightride_fm',
        'facebook': 'https://www.facebook.com/nightridefm/',
      },
    ),
  ];

  // Programas académicos de demostración.
  static const programs = <ProgramModel>[
    ProgramModel(
      id: 'p1',
      stationId: 'gsl',
      title: 'Ambient Chill',
      description: 'Música ambiental sin interrupciones y ritmos suaves.',
      schedule: 'Selección de prueba · Todo el día',
      imageUrl: 'https://somafm.com/img/GrooveSaladBox.jpg',
    ),

    ProgramModel(
      id: 'p2',
      stationId: 'sag',
      title: 'Espionaje Sonoro',
      description: 'Jazz instrumental y lounge retro para una noche elegante.',
      schedule: 'Selección de prueba · Todo el día',
      imageUrl: 'https://somafm.com/img/SecretAgentBox.jpg',
    ),

    ProgramModel(
      id: 'p3',
      stationId: 'ipr',
      title: 'Indie Sessions',
      description: 'Novedades del rock alternativo y favoritos indie.',
      schedule: 'Selección de prueba · Todo el día',
      imageUrl: 'https://somafm.com/img/indychick.jpg',
    ),

    ProgramModel(
      id: 'p4',
      stationId: 'nrfm',
      title: 'Cyber Grid',
      description: 'Lo-fi synthwave y cyberpunk beats de prueba.',
      schedule: 'Selección de prueba · Todo el día',
    ),
  ];

  // Busca una estación por su identificador.
  static StationModel? stationById(String id) {
    for (final station in stations) {
      if (station.id == id) {
        return station;
      }
    }

    return null;
  }

  static List<ProgramModel> programsFor(String? stationId) {
    if (stationId == null) {
      return programs;
    }

    return programs.where((program) => program.stationId == stationId).toList();
  }
}
