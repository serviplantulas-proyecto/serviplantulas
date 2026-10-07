import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {

  // ═══════════════════════════════
  // TÍTULOS
  // ═══════════════════════════════

  static TextStyle titleLarge = GoogleFonts.manrope(
    fontSize: 28,
    fontWeight: FontWeight.w800, // ExtraBold
    color: AppColors.textPrimary,
  );

  static TextStyle titleMedium = GoogleFonts.manrope(
    fontSize: 24,
    fontWeight: FontWeight.w700, // Bold
    color: AppColors.textPrimary,
  );

  static TextStyle titleSmall = GoogleFonts.manrope(
    fontSize: 18,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textPrimary,
  );

  // ═══════════════════════════════
  // TEXTO NORMAL
  // ═══════════════════════════════

  static TextStyle bodyLarge = GoogleFonts.manrope(
    fontSize: 15,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.textPrimary,
  );

  static TextStyle bodySmall = GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // ═══════════════════════════════
  // BOTONES
  // ═══════════════════════════════

  static TextStyle button = GoogleFonts.manrope(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  // ═══════════════════════════════
  // LABELS / AYUDAS
  // ═══════════════════════════════

  static TextStyle label = GoogleFonts.manrope(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );
}