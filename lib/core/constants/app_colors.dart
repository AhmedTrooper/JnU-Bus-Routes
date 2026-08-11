import 'package:flutter/material.dart';

/// Uber Signature Luxury Dark Palette
abstract class AppColors {
  static const Color pitchBlack = Color(0xFF000000);
  static const Color uberDarkCard = Color(0xFF161618);
  static const Color uberDarkElevated = Color(0xFF222226);
  static const Color uberBorder = Color(0xFF2C2C30);

  static const Color uberBlue = Color(0xFF276EF1);
  static const Color uberGold = Color(0xFFFACC15);
  static const Color uberGreen = Color(0xFF10B981);
  static const Color uberRed = Color(0xFFEF4444);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF6B7280);

  // CartoDB Dark Tiles default URL for Uber map aesthetic
  static const String uberDarkTileUrl =
      'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';
}
