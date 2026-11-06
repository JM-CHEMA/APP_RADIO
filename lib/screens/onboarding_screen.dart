import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_app/app_theme.dart';
import 'package:radio_app/helpers/providers/app_provider.dart';
import 'package:radio_app/screens/home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Center(child: SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.headphones, size: 90, color: AppColors.primary),
        const SizedBox(height: AppSpacing.large),
        Text('Bienvenido a Radio App', textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.medium),
        Text('Descubre cuatro estaciones de radio internacional y disfruta de sus programas.',
          textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: () {
            context.read<AppProvider>().markOnboardingCompleted();
            Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
              builder: (context) => const HomeScreen(),
            ));
          },
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Comenzar'),
        ),
      ]),
    ))),
  );
}
