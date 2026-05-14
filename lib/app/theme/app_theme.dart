import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  // Base — Alpine Cold
  static const Color glacierWhite = Color(0xFFF4F7FA);
  static const Color snowFog = Color(0xFFECF1F6);
  static const Color glacierBlue = Color(0xFF5B9BD5);
  static const Color deepGlacier = Color(0xFF2D6A9F);
  static const Color iceBlue = Color(0xFFB8D4EC);
  static const Color slateGray = Color(0xFF4A5568);
  static const Color charcoal = Color(0xFF1A202C);
  static const Color inkDark = Color(0xFF0D1117);

  // Accents- Festival Vivid
  static const Color saffron = Color(0xFFFF9F0A);
  static const Color coral = Color(0xFFFF6B6B);
  static const Color electricTeal = Color(0xFF00D4C8);
  static const Color marigold = Color(0xFFFFBF00);

  // Utility
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFDDE3EC);
  static const Color textPrimary = Color(0xFF1A202C);
  static const Color textSub = Color(0xFF6B7A8D);
  static const Color textLight = Color(0xFF9EAABB);
  static const Color overlayDark = Color(0xCC0D1117);
  static const Color overlayMid = Color(0x991A202C);
}

// GRADIENTS

class AppGradients {
  AppGradients._();

  static const LinearGradient heroOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x00000000), Color(0xDD0D1117)],
    stops: [0.3, 1.0],
  );

  static const LinearGradient saffronAccent = LinearGradient(
    colors: [AppColors.saffron, AppColors.coral],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tealAccent = LinearGradient(
    colors: [AppColors.electricTeal, AppColors.glacierBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardBottom = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x00000000), Color(0xEE0D1117)],
    stops: [0.45, 1.0],
  );
}

// SHADOWS

class AppShadows {
  AppShadows._();

  static List<BoxShadow> get card => [
        BoxShadow(
          color: AppColors.slateGray.withAlpha(30),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> get soft => [
        BoxShadow(
          color: AppColors.glacierBlue.withAlpha(40),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get button => [
        BoxShadow(
          color: AppColors.saffron.withAlpha(40),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ];
}

// ADII

class AppRadius {
  AppRadius._();

  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double full = 999;
}

// TYPOGRAPHY

class AppTypography {
  AppTypography._();

  static TextStyle display1(BuildContext context) => GoogleFonts.syne(
        fontSize: 42,
        fontWeight: FontWeight.w800,
        color: AppColors.glacierWhite,
        height: 1.1,
        letterSpacing: -1.5,
      );

  static TextStyle display2(BuildContext context) => GoogleFonts.syne(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
        letterSpacing: -0.8,
      );

  static TextStyle headline(BuildContext context) => GoogleFonts.syne(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle subhead(BuildContext context) => GoogleFonts.dmSans(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.textSub,
        height: 1.5,
      );

  static TextStyle body(BuildContext context) => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSub,
        height: 1.6,
      );

  static TextStyle caption(BuildContext context) => GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textLight,
        height: 1.4,
        letterSpacing: 0.2,
      );

  static TextStyle label(BuildContext context) => GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.textLight,
        height: 1.3,
        letterSpacing: 1.2,
      );

  static TextStyle button(BuildContext context) => GoogleFonts.syne(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.cardWhite,
        letterSpacing: 0.4,
      );
}

// THEME DATA

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.glacierWhite,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.glacierBlue,
          primary: AppColors.glacierBlue,
          secondary: AppColors.saffron,
          surface: AppColors.cardWhite,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: AppColors.charcoal,
        ),
        cardTheme: CardThemeData(
          color: AppColors.cardWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.saffron,
            foregroundColor: AppColors.cardWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            elevation: 0,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.cardWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
            borderSide:
                const BorderSide(color: AppColors.glacierBlue, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          hintStyle: GoogleFonts.dmSans(
            color: AppColors.textLight,
            fontSize: 14,
          ),
        ),
      );
}
