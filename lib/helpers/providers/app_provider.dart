import 'package:flutter/foundation.dart';

// Estado de navegación / onboarding. Por ahora solo almacena la finalización.
// No se persiste entre inicios: la lección no solicita almacenamiento local.
class AppProvider extends ChangeNotifier {
  bool _onboardingCompleted = false;
  bool get onboardingCompleted => _onboardingCompleted;

  void markOnboardingCompleted() {
    if (_onboardingCompleted) return;
    _onboardingCompleted = true;
    notifyListeners();
  }
}
