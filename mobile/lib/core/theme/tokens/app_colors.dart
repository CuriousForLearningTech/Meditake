import 'package:flutter/material.dart';

/// ┌──────────────────────────────────────────────────────────────┐
/// │  SGMS Enterprise Color Tokens                                │
/// │  Single source of truth — every UI element derives from here │
/// └──────────────────────────────────────────────────────────────┘

/// Semantic color interface — both [LightColors] and [DarkColors] share the
/// same field names so widgets only need to reference `AppColors.of(context)`.
class AppColorScheme {
  // ── Brand ──────────────────────────────────────────────────────
  final Color primary;
  final Color primaryContainer;
  final Color onPrimary;
  final Color secondary;
  final Color tertiary;

  // ── Surfaces ───────────────────────────────────────────────────
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color card;
  final Color cardBorder;

  // ── Text ───────────────────────────────────────────────────────
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textOnPrimary;

  // ── Status ─────────────────────────────────────────────────────
  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  // ── Interactive ────────────────────────────────────────────────
  final Color divider;
  final Color inputFill;
  final Color inputBorder;
  final Color shimmerBase;
  final Color shimmerHighlight;

  // ── Overlay / Glass ────────────────────────────────────────────
  final Color navBarBackground;
  final Color navBarBorder;
  final Color shadow;

  const AppColorScheme({
    required this.primary,
    required this.primaryContainer,
    required this.onPrimary,
    required this.secondary,
    required this.tertiary,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.card,
    required this.cardBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textOnPrimary,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.divider,
    required this.inputFill,
    required this.inputBorder,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.navBarBackground,
    required this.navBarBorder,
    required this.shadow,
  });
}

/// ─── Light Palette ──────────────────────────────────────────────
class LightColors {
  static const scheme = AppColorScheme(
    // Brand
    primary: Color(0xFF4A90E2),
    primaryContainer: Colors.white,
    onPrimary: Colors.white,
    secondary: Color(0xFF7CC6FE),
    tertiary: Color(0xFF123B6D),

    // Surfaces
    background: Color(0xFFF8FBFF),
    surface: Colors.white,
    surfaceVariant: Color(0xFFF1F5F9),
    card: Colors.white,
    cardBorder: Color(0xFFE2E8F0),

    // Text
    textPrimary: Color(0xFF123B6D),
    textSecondary: Color.fromARGB(255, 32, 38, 45),
    textMuted: Color.fromARGB(255, 102, 112, 126),
    textOnPrimary: Colors.white,

    // Status
    success: Color(0xFF7ED957),
    warning: Color(0xFFFFB547),
    error: Color(0xFFFF6B6B),
    info: Color(0xFF3B82F6),

    // Interactive
    divider: Color(0xFFE2E8F0),
    inputFill: Colors.white,
    inputBorder: Color(0xFF4A90E2),
    shimmerBase: Color(0xFF7CC6FE),
    shimmerHighlight: Color(0xFF7CC6FE),

    // Overlay
    navBarBackground: Color(0xF2FFFFFF), // white 95%
    navBarBorder: Color(0x19FFFFFF), // white 10%
    shadow: Color(0xFF123B6D), // black 4%
  );
}

/// ─── Dark Palette ───────────────────────────────────────────────
class DarkColors {
  static const scheme = AppColorScheme(
    // Brand — slightly brighter for dark bg
    primary: Color(0xFF69AFFF),
    primaryContainer: Color(0xFF1C3B63),
    onPrimary: Color(0xFF0F1724),
    secondary: Color(0xFF8FD1FF),
    tertiary: Color(0xFF8FE36A),

    // Backgrounds & Surfaces
    background: Color(0xFF0F1724),
    surface: Color(0xFF1A2535),
    surfaceVariant: Color(0xFF263548),
    card: Color(0xFF1A2535),
    cardBorder: Color(0xFF314357),

    // Text
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFFCBD5E1),
    textMuted: Color(0xFF94A3B8),
    textOnPrimary: Color(0xFF0F1724),

    // Status
    success: Color(0xFF7ED957),
    warning: Color(0xFFFFB547),
    error: Color(0xFFFF6B6B),
    info: Color(0xFF3B82F6),

    // Interactive
    divider: Color(0xFF334155),
    inputFill: Color(0xFF1E293B),
    inputBorder: Color(0xFF475569),
    shimmerBase: Color(0xFF334155),
    shimmerHighlight: Color(0xFF475569),

    // Overlay
    navBarBackground: Color(0xF21E293B), // slate-800 95%
    navBarBorder: Color(0x19FFFFFF), // white 10%
    shadow: Color(0x33000000), // black 20%
  );
}

/// ─── Static legacy accessor (for non-context areas) ─────────────
/// Prefer [AppColors.of(context)] in widgets.
class AppColors {
  // Brand (light defaults)
  static const primary = Color(0xFF4A90E2);
  static const secondary = Color(0xFF7CC6FE);
  static const tertiary = Color(0xFF123B6D);

  // Status
  static const success = Color(0xFF7ED957);
  static const warning = Color(0xFFFFB547);
  static const error = Color(0xFFFF6B6B);
  static const info = Color(0xFF3B82F6);

  /// Resolve the correct [AppColorScheme] for the current theme brightness.
  static AppColorScheme of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? DarkColors.scheme
        : LightColors.scheme;
  }
}
