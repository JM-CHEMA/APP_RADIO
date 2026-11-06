// Datos de una estación. No contiene widgets ni operaciones de reproducción.
class StationModel {
  final String id;
  final String name;
  final String acronym;
  final String slogan;
  final String streamUrl;
  final String? imageUrl;
  final String? websiteUrl;
  // La clave indica la red (instagram, facebook, bluesky, x, discord, etc.).
  final Map<String, String> socialLinks;

  const StationModel({
    required this.id,
    required this.name,
    required this.acronym,
    required this.slogan,
    required this.streamUrl,
    this.imageUrl,
    this.websiteUrl,
    this.socialLinks = const {},
  });
}
