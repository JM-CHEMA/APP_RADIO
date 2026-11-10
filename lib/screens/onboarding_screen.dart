import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_app/app_theme.dart';
import 'package:radio_app/helpers/providers/app_provider.dart';
import 'package:radio_app/screens/home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final imageHeight = (constraints.maxHeight * 0.42).clamp(
              210.0,
              310.0,
            );

            return Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.large,
                AppSpacing.normal,
                AppSpacing.large,
                AppSpacing.large,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    children: [
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, available) {
                            return SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: available.maxHeight,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/iconRadio.png',
                                      width: double.infinity,
                                      height: imageHeight,
                                      fit: BoxFit.contain,
                                    ),

                                    const SizedBox(height: AppSpacing.large),

                                    Container(
                                      width: 42,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: AppColors.accent,
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.small,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: AppSpacing.large),

                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Bienvenido a\n',
                                            style: AppTextStyles.sectionTitle
                                                .copyWith(
                                                  fontSize: 29,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          TextSpan(
                                            text: 'Radio App',
                                            style: AppTextStyles.sectionTitle
                                                .copyWith(
                                                  fontSize: 34,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppColors.accent,
                                                ),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                    const SizedBox(height: AppSpacing.normal),

                                    Text(
                                      'Descubre cuatro estaciones de radio internacional y disfruta de sus programas.',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.sectionSubtitle
                                          .copyWith(fontSize: 15, height: 1.6),
                                    ),

                                    const SizedBox(height: AppSpacing.large),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: AppSpacing.medium),

                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: () {
                            context
                                .read<AppProvider>()
                                .markOnboardingCompleted();

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute<void>(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: AppColors.backgroundPrimary,
                            elevation: 6,
                            shadowColor: AppColors.accent.withValues(
                              alpha: 0.28,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.card,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Comenzar', style: AppTextStyles.button),

                              const SizedBox(width: 12),

                              const Icon(Icons.arrow_forward_rounded, size: 21),
                            ],
                          ),
                        ),
                      ),
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
