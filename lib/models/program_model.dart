// Programa de demostración; stationId sirve para filtrar por estación activa.
class ProgramModel {
  final String id;
  final String stationId;
  final String title;
  final String description;
  final String schedule;
  final String? imageUrl;

  const ProgramModel({
    required this.id,
    required this.stationId,
    required this.title,
    required this.description,
    required this.schedule,
    this.imageUrl,
  });
}
