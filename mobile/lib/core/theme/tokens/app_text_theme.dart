import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// ┌──────────────────────────────────────────────────────────────┐
/// │  SGMS Enterprise Typography Tokens                           │
/// │  Theme-agnostic — colors are applied via ThemeData.textTheme │
/// └──────────────────────────────────────────────────────────────┘
class AppTextTheme {
  /// Base text theme with no colors — colors come from the active theme.
  static TextTheme get textTheme {
    return TextTheme(
      // Headlines
      displayLarge: GoogleFonts.manrope(
        fontSize: 32.sp,
        fontWeight: FontWeight.w900,
      ),
      displayMedium: GoogleFonts.manrope(
        fontSize: 28.sp,
        fontWeight: FontWeight.w800,
      ),
      displaySmall: GoogleFonts.manrope(
        fontSize: 24.sp,
        fontWeight: FontWeight.w800,
      ),

      // Titles
      titleLarge: GoogleFonts.manrope(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: GoogleFonts.manrope(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: GoogleFonts.manrope(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),

      // Body
      bodyLarge: GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
      ),

      // Labels
      labelLarge: GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
