import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceVariant: AppColors.surfaceContainerHighest,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.geist(
          fontSize: 64,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.04 * 64,
          color: AppColors.onSurface.withOpacity(0.9),
        ),
        displayMedium: GoogleFonts.geist(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02 * 40,
          color: AppColors.onSurface.withOpacity(0.9),
        ),
        headlineLarge: GoogleFonts.geist(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.02 * 32,
          color: AppColors.onSurface.withOpacity(0.9),
        ),
        headlineMedium: GoogleFonts.geist(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface.withOpacity(0.9),
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurface.withOpacity(0.9),
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurface.withOpacity(0.9),
        ),
        labelLarge: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.05 * 14,
          color: AppColors.onSurface.withOpacity(0.9),
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface.withOpacity(0.9),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.neonCyan),
        ),
        labelStyle: GoogleFonts.inter(color: AppColors.onSurfaceVariant),
        hintStyle: GoogleFonts.inter(color: AppColors.onSurfaceVariant.withOpacity(0.5)),
      ),
    );
  }
}
