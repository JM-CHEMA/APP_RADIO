import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppColors {
  static const backgroundPrimary = Color.fromARGB(255, 254, 254, 254);
  static const background = Color.fromARGB(255, 240, 243, 244);
  static const surface = Color(0xFF235660);
  static const surfaceRaised = Color(0xFF326E79);
  static const primary = Color(0xFF78F4E8);
  static const accent = Color(0xFF087BFA);
  static const textPrimary = Color.fromARGB(255, 0, 0, 0);
  static const textSecondary = Color(0xFFBCDCD7);
  static const onPrimary = Color(0xFF10343A);
  static const error = Color(0xFFFF8E8E);

  static const title = Color(0xFF161B22);
  static const subtitle = Color(0xFF7B8492);
  static const muted = Color(0xFF8893A2);
  static const border = Color(0xFFEDF0F4);

  static const playerBackground = Color(0xFF101820);
  static const playerSurface = Color(0xFF1C2936);
  static const playerText = Color(0xFFF8FAFC);
  static const playerMuted = Color(0xFF9AA9BA);
}

abstract final class AppSpacing {
  static const extraSmall = 4.0;
  static const small = 8.0;
  static const medium = 12.0;
  static const normal = 16.0;
  static const large = 24.0;
  static const extraLarge = 32.0;
  static const section = 40.0;
}

abstract final class AppRadius {
  static const small = 12.0;
  static const medium = 14.0;
  static const normal = 16.0;
  static const card = 20.0;
  static const artwork = 24.0;
  static const bottomSheet = 28.0;
}

abstract final class AppShadows {
  static final List<BoxShadow> card = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ];

  static final List<BoxShadow> program = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.10),
      blurRadius: 18,
      offset: const Offset(0, 7),
    ),
  ];

  static final List<BoxShadow> miniPlayer = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static final List<BoxShadow> artwork = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.35),
      blurRadius: 25,
      offset: const Offset(0, 12),
    ),
  ];
}

abstract final class AppTextStyles {
  static final TextStyle appTitle = GoogleFonts.inter(
    fontSize: 23,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.7,
    color: AppColors.title,
  );

  static final TextStyle sectionTitle = GoogleFonts.inter(
    fontSize: 23,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.7,
    color: AppColors.title,
  );

  static final TextStyle sectionSubtitle = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.subtitle,
  );

  static final TextStyle stationTitle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    color: AppColors.title,
  );

  static final TextStyle stationAcronym = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
    color: AppColors.muted,
  );

  static final TextStyle stationDescription = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.subtitle,
  );

  static final TextStyle miniPlayerTitle = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    color: AppColors.title,
  );

  static final TextStyle miniPlayerStatus = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.muted,
  );

  static final TextStyle programTitle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.25,
    color: Colors.white,
  );

  static final TextStyle programDescription = GoogleFonts.inter(
    fontSize: 11.5,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: const Color(0xFFE0E0E0),
  );

  static final TextStyle playerTitle = GoogleFonts.inter(
    fontSize: 25,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.6,
    color: AppColors.playerText,
  );

  static final TextStyle playerSubtitle = GoogleFonts.inter(
    fontSize: 13,
    height: 1.5,
    color: AppColors.playerMuted,
  );

  static final TextStyle playerSectionLabel = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
    color: AppColors.playerMuted,
  );

  static final TextStyle button = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}

abstract final class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ).copyWith(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          error: AppColors.error,
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      centerTitle: false,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
    ),
    textTheme: TextTheme(
      headlineMedium: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.inter(fontSize: 16, color: AppColors.textPrimary),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        color: AppColors.textSecondary,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        color: AppColors.textSecondary,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: AppTextStyles.button,
        elevation: 8,
        shadowColor: AppColors.accent.withValues(alpha: 0.4),
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    iconTheme: const IconThemeData(color: AppColors.primary),
  );
}
