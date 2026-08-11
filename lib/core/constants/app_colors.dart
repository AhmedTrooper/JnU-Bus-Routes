import 'package:flutter/material.dart';

/// World-Class Luxury Palette with Dark & Light Mode Theme Support
abstract class AppColors {
  // Brand Accents
  static const Color primaryRed = Color(0xFFDC2626); // Crimson Red
  static const Color accentBlue = Color(0xFF2563EB); // Electric Royal Blue
  static const Color accentGold = Color(0xFFF59E0B); // Gold Yellow
  static const Color successGreen = Color(0xFF10B981); // Emerald Green

  // Dark Theme Palette (Obsidian Black Canvas & Circle Badges)
  static const Color darkCanvas = Color(0xFF09090B);
  static const Color darkCard = Color(0xFF18181B);
  static const Color darkElevated = Color(0xFF27272A);
  static const Color darkBorder = Color(0xFF3F3F46);

  // Light Theme Palette (Pristine White Canvas & Crisp Red/Green Accents)
  static const Color lightCanvas = Color(0xFFFAFAFA);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightElevated = Color(0xFFF4F4F5);
  static const Color lightBorder = Color(0xFFE4E4E7);

  // Text Colors
  static const Color textDarkPrimary = Color(0xFFFAFAFA);
  static const Color textDarkSecondary = Color(0xFFA1A1AA);
  static const Color textLightPrimary = Color(0xFF09090B);
  static const Color textLightSecondary = Color(0xFF71717A);

  // Aliases for compatibility
  static const Color pitchBlack = darkCanvas;
  static const Color uberDarkCard = darkCard;
  static const Color uberDarkElevated = darkElevated;
  static const Color uberBorder = darkBorder;
  static const Color uberBlue = accentBlue;
  static const Color uberGold = accentGold;
  static const Color uberGreen = successGreen;
  static const Color uberRed = primaryRed;

  static const Color textPrimary = textDarkPrimary;
  static const Color textSecondary = textDarkSecondary;
  static const Color textMuted = textDarkSecondary;

  // Tile Providers
  static const String darkTileUrl = 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';
  static const String lightTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
}
