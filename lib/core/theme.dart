import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens taken from the Figma "Design System" (Dark mode).
class AppColors {
  static const canvas = Color(0xFF0A0A0A); // bg/canvas  (neutral/950)
  static const surface = Color(0xFF141414); // bg/surface (neutral/900)
  static const raised = Color(0xFF1F1F1F); // bg/raised  (neutral/850)
  static const borderStrong = Color(0xFF3D3D3D); // border/strong (neutral/700)
  static const textPrimary = Color(0xFFFAFAFA); // text/primary
  static const textSecondary = Color(0xFFA3A3A3); // text/secondary
  static const accent = Colors.white; // accent/default
  static const onAccent = Color(0xFF0A0A0A); // text/on-accent
  static const danger = Color(0xFFEF5350); // status/red-300
  static const safe = Color(0xFF66BB6A); // status/green-300
  static const cyan = Color(0xFF00BFFF); // brand/cyan (glasses / lens)
}

class AppSpace {
  static const double xxs = 4, xs = 8, sm = 12, md = 16, lg = 24, xl = 32, xxl = 48;
}

class AppRadius {
  static const double sm = 6, md = 10, lg = 16;
}

class AppText {
  static final h1 = GoogleFonts.inter(
      fontSize: 32, height: 40 / 32, fontWeight: FontWeight.w700, letterSpacing: -0.32, color: AppColors.textPrimary);
  static final bodyLarge = GoogleFonts.inter(
      fontSize: 18, height: 28 / 18, fontWeight: FontWeight.w400, color: AppColors.textSecondary);
  static final body = GoogleFonts.inter(
      fontSize: 16, height: 24 / 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary);
  static final bodySecondary = body.copyWith(color: AppColors.textSecondary);
  static final bodySmall = GoogleFonts.inter(
      fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary);
  static final label = GoogleFonts.inter(
      fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary);
  static final labelLarge = GoogleFonts.inter(
      fontSize: 18, height: 24 / 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static final caption = GoogleFonts.inter(
      fontSize: 12, height: 16 / 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary);
  static final wordmark = GoogleFonts.syncopate(
      fontSize: 15, height: 16 / 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
}

ThemeData buildAppTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.canvas,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      onPrimary: AppColors.onAccent,
      surface: AppColors.surface,
      error: AppColors.danger,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.raised,
      contentTextStyle: AppText.body,
    ),
  );
}
