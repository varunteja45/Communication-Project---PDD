import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central design system for AECCDE.
///
/// Palette is deliberately "communication lab" flavored — deep indigo
/// for focus/analysis surfaces, teal for positive competency signals,
/// amber/red reserved strictly for score warnings.
class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF3949AB); // indigo
  static const Color primaryDark = Color(0xFF1A237E);
  static const Color accentTeal = Color(0xFF00BFA5);
  static const Color accentAmber = Color(0xFFFFB300);
  static const Color accentRed = Color(0xFFE53935);
  static const Color surfaceLight = Color(0xFFF6F7FB);
  static const Color surfaceDark = Color(0xFF121218);
  static const Color cardDark = Color(0xFF1D1E27);

  static const List<Color> scoreGradient = [
    Color(0xFFE53935),
    Color(0xFFFFB300),
    Color(0xFF00BFA5),
  ];

  static Color scoreColor(double score) {
    if (score < 40) return accentRed;
    if (score < 70) return accentAmber;
    return accentTeal;
  }

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: surfaceLight,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceLight,
        foregroundColor: primaryDark,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          color: primaryDark,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: surfaceDark,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceDark,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentTeal,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }
}
