import 'package:flutter/material.dart';

/// Minimalist Apple Glassmorphism Color Palette
abstract class AppColors {
  // Apple Dark Mode Glass Colors
  static const Color darkCanvas = Color(0xFF000000); // Pure Apple Black
  static const Color darkGlassSurface = Color(0xCC1C1C1E); // 80% opacity dark glass
  static const Color darkGlassBorder = Color(0x33FFFFFF); // 20% opacity white edge
  static const Color darkGlassElevated = Color(0x992C2C2E);

  // Apple Light Mode Glass Colors
  static const Color lightCanvas = Color(0xFFF2F2F7); // Apple System Gray 6
  static const Color lightGlassSurface = Color(0xCCFFFFFF); // 80% opacity white glass
  static const Color lightGlassBorder = Color(0x1F000000); // 12% opacity black edge
  static const Color lightGlassElevated = Color(0xE5F2F2F7);

  // Apple System Accents
  static const Color appleBlue = Color(0xFF0A84FF); // Apple Dark Mode Blue
  static const Color appleGreen = Color(0xFF30D158); // Apple System Green
  static const Color appleOrange = Color(0xFFFF9F0A); // Apple System Orange
  static const Color appleRed = Color(0xFFFF453A); // Apple System Red

  // Text Colors
  static const Color textDarkPrimary = Color(0xFFFFFFFF);
  static const Color textDarkSecondary = Color(0x99EBF5FF);
  static const Color textDarkMuted = Color(0x66EBF5FF);

  static const Color textLightPrimary = Color(0xFF000000);
  static const Color textLightSecondary = Color(0x993C3C43);
  static const Color textLightMuted = Color(0x4D3C3C43);

  // Compatibility Aliases
  static const Color pitchBlack = darkCanvas;
  static const Color uberDarkCard = darkGlassSurface;
  static const Color uberDarkElevated = darkGlassElevated;
  static const Color uberBorder = darkGlassBorder;
  static const Color uberBlue = appleBlue;
  static const Color uberGold = appleOrange;
  static const Color uberGreen = appleGreen;
  static const Color uberRed = appleRed;

  static const Color primaryRed = appleRed;
  static const Color accentBlue = appleBlue;
  static const Color accentGold = appleOrange;
  static const Color successGreen = appleGreen;

  static const Color textPrimary = textDarkPrimary;
  static const Color textSecondary = textDarkSecondary;
  static const Color textMuted = textDarkMuted;

  // Map Tile Providers
  static const String darkTileUrl = 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';
  static const String lightTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
}
