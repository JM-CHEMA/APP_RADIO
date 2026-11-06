import 'package:url_launcher/url_launcher.dart';

// Apertura de enlaces externos en un solo lugar, fuera de los widgets.
class AppService {
  const AppService();

  Future<bool> openExternalLink(String? url) async {
    if (url == null || url.trim().isEmpty) return false;
    final uri = Uri.tryParse(url.trim());
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) return false;
    try {
      // Esta comprobación necesita <queries> de https en Android 11+.
      // canLaunchUrl puede dar un falso negativo en algunas plataformas;
      // si sucede, intentamos abrir igual y capturamos el fallo.
      final supported = await canLaunchUrl(uri);
      if (!supported) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}
