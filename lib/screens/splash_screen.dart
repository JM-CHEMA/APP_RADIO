import 'package:flutter/material.dart';
import 'package:radio_app/app_theme.dart';
import 'package:radio_app/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goToOnboarding();
  }

  Future<void> _goToOnboarding() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
      builder: (context) => const OnboardingScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.radio, color: AppColors.primary, size: 100),
      const SizedBox(height: AppSpacing.large),
      Text('RADIO APP', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: AppSpacing.small),
      Text('Tu música y estaciones favoritas',
        style: Theme.of(context).textTheme.bodyMedium),
    ])),
  );
}
