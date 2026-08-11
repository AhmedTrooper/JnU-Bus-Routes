import 'package:flutter/material.dart';

/// Production-Grade Shadcn UI Design Tokens (Zinc Dark & Light Palette)
abstract class AppColors {
  // Dark Theme Tokens (Shadcn Zinc 950)
  static const Color darkBackground = Color(0xFF09090B); // zinc-950
  static const Color darkCard = Color(0xFF18181B); // zinc-900
  static const Color darkMuted = Color(0xFF27272A); // zinc-800
  static const Color darkBorder = Color(0xFF27272A); // zinc-800 border
  static const Color darkBorderActive = Color(0xFF3F3F46); // zinc-700
  static const Color darkForeground = Color(0xFFFAFAFA); // zinc-50
  static const Color darkMutedForeground = Color(0xFFA1A1AA); // zinc-400

  // Light Theme Tokens (Shadcn Zinc 50)
  static const Color lightBackground = Color(0xFFFAFAFA); // zinc-50
  static const Color lightCard = Color(0xFFFFFFFF); // white
  static const Color lightMuted = Color(0xFFF4F4F5); // zinc-100
  static const Color lightBorder = Color(0xFFE4E4E7); // zinc-200
  static const Color lightBorderActive = Color(0xFFD4D4D8); // zinc-300
  static const Color lightForeground = Color(0xFF09090B); // zinc-950
  static const Color lightMutedForeground = Color(0xFF71717A); // zinc-500

  // Shadcn Brand & Status Tokens
  static const Color shadcnPrimary = Color(0xFF18181B); // zinc-900
  static const Color shadcnBlue = Color(0xFF2563EB); // blue-600
  static const Color shadcnEmerald = Color(0xFF10B981); // emerald-500
  static const Color shadcnAmber = Color(0xFFF59E0B); // amber-500
  static const Color shadcnRose = Color(0xFFF43F5E); // rose-500

  // Legacy Aliases for seamless compatibility
  static const Color darkCanvas = darkBackground;
  static const Color lightCanvas = lightBackground;
  static const Color darkGlassSurface = darkCard;
  static const Color darkGlassBorder = darkBorder;
  static const Color darkGlassElevated = darkMuted;
  static const Color lightGlassSurface = lightCard;
  static const Color lightGlassBorder = lightBorder;
  static const Color lightGlassElevated = lightMuted;

  static const Color pitchBlack = darkBackground;
  static const Color uberDarkCard = darkCard;
  static const Color uberDarkElevated = darkMuted;
  static const Color uberBorder = darkBorder;
  static const Color uberBlue = shadcnBlue;
  static const Color uberGold = shadcnAmber;
  static const Color uberGreen = shadcnEmerald;
  static const Color uberRed = shadcnRose;

  static const Color primaryRed = shadcnRose;
  static const Color accentBlue = shadcnBlue;
  static const Color accentGold = shadcnAmber;
  static const Color successGreen = shadcnEmerald;
  static const Color appleBlue = shadcnBlue;
  static const Color appleGreen = shadcnEmerald;
  static const Color appleOrange = shadcnAmber;
  static const Color appleRed = shadcnRose;

  static const Color textDarkPrimary = darkForeground;
  static const Color textDarkSecondary = darkMutedForeground;
  static const Color textDarkMuted = darkMutedForeground;
  static const Color textLightPrimary = lightForeground;
  static const Color textLightSecondary = lightMutedForeground;
  static const Color textLightMuted = lightMutedForeground;

  static const Color textPrimary = darkForeground;
  static const Color textSecondary = darkMutedForeground;
  static const Color textMuted = darkMutedForeground;

  // Map Tile Providers
  static const String darkTileUrl = 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';
  static const String lightTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
}
