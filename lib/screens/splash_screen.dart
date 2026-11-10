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

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (context) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final imageSize = constraints.maxHeight < 650 ? 200.0 : 280.0;

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.large,
                vertical: AppSpacing.large,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    children: [
                      const Spacer(),

                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.92, end: 1.0),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: ((value - 0.92) / 0.08).clamp(0.0, 1.0),
                            child: Transform.scale(scale: value, child: child),
                          );
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/icons/iconRadio.png',
                              width: imageSize,
                              height: imageSize,
                              fit: BoxFit.contain,
                            ),

                            const SizedBox(height: 32),

                            Text(
                              'RADIO APP',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.appTitle.copyWith(
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2,
                              ),
                            ),

                            const SizedBox(height: 14),

                            Text(
                              'Tu música y estaciones favoritas',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.sectionSubtitle.copyWith(
                                fontSize: 15,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 24),

                            Container(
                              width: 48,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.small,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      const SizedBox(
                        width: 26,
                        height: 26,
                        child: CircularProgressIndicator(
                          color: AppColors.accent,
                          strokeWidth: 2.5,
                        ),
                      ),

                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
