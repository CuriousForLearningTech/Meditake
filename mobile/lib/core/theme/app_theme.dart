import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './tokens/app_colors.dart';
import './tokens/app_text_theme.dart';
import './tokens/app_dimensions.dart';

/// ┌──────────────────────────────────────────────────────────────┐
/// │  SGMS Enterprise ThemeData Builder                            │
/// │  Generates fully-defined Light & Dark themes from tokens     │
/// └──────────────────────────────────────────────────────────────┘
class AppTheme {
  // ── Light Theme ────────────────────────────────────────────────
  static ThemeData get lightTheme {
    const c = LightColors.scheme;
    return _buildTheme(c, Brightness.light);
  }

  // ── Dark Theme ─────────────────────────────────────────────────
  static ThemeData get darkTheme {
    const c = DarkColors.scheme;
    return _buildTheme(c, Brightness.dark);
  }

  // ── Shared Builder ─────────────────────────────────────────────
  static ThemeData _buildTheme(AppColorScheme c, Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final textTheme = AppTextTheme.textTheme.apply(
      bodyColor: c.textPrimary,
      displayColor: c.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,

      // ── Color Scheme ───────────────────────────────────────────
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: c.primary,
        onPrimary: c.onPrimary,
        primaryContainer: c.primaryContainer,
        onPrimaryContainer: c.textPrimary,
        secondary: c.secondary,
        onSecondary: Colors.white,
        secondaryContainer: c.surfaceVariant,
        onSecondaryContainer: c.textPrimary,
        tertiary: c.tertiary,
        onTertiary: Colors.white,
        error: c.error,
        onError: Colors.white,
        surface: c.surface,
        onSurface: c.textPrimary,
        onSurfaceVariant: c.textSecondary,
        outline: c.inputBorder,
        outlineVariant: c.divider,
        shadow: c.shadow,
      ),

      // ── Scaffold ───────────────────────────────────────────────
      scaffoldBackgroundColor: c.background,
      canvasColor: c.surface,
      cardColor: c.card,
      dividerColor: c.divider,

      // ── Typography ─────────────────────────────────────────────
      textTheme: textTheme,

      // ── AppBar ─────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: c.surface,
        foregroundColor: c.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),

      // ── Card ───────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: c.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: c.cardBorder, width: 1),
        ),
      ),

      // ── Elevated Button ────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: c.onPrimary,
          disabledBackgroundColor: c.primary.withValues(alpha: 0.6),
          disabledForegroundColor: c.onPrimary.withValues(alpha: 0.7),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),

      // ── Outlined Button ────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.textPrimary,
          side: BorderSide(color: c.primary, style: BorderStyle.solid),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),

      // ── Text Button ────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: c.primary),
      ),

      // ── Input / TextField ──────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.inputFill,
        hintStyle: TextStyle(color: c.textMuted),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: c.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: c.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: c.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: c.error),
        ),
      ),

      // ── Bottom Sheet ───────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      // ── Dialog ─────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
      ),

      // ── Snackbar ───────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? c.surfaceVariant : c.textPrimary,
        contentTextStyle: TextStyle(
          color: isDark ? c.textPrimary : Colors.white,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),

      // ── Divider ────────────────────────────────────────────────
      dividerTheme: DividerThemeData(color: c.divider, thickness: 1, space: 1),

      // ── Icon ───────────────────────────────────────────────────
      iconTheme: IconThemeData(color: c.textSecondary),
    );
  }
}
