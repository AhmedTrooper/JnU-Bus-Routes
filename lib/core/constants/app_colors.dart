import 'package:flutter/material.dart';

/// Ultra-modern Uber-style dark & light color palette
abstract class AppColors {
  // Brand Colors (Uber Dark & Vivid Gold Accent)
  static const Color primary = Color(0xFF000000);
  static const Color accent = Color(0xFF276EF1); // Uber Blue
  static const Color accentGold = Color(0xFFFFC043); // JnU Gold / Yellow
  static const Color successGreen = Color(0xFF05A357); // Live / Active / Passed
  static const Color warningOrange = Color(0xFFFF8800);
  static const Color dangerRed = Color(0xFFE11900);

  // Dark Theme Backgrounds & Surfaces
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceElevated = Color(0xFF2A2A2A);
  static const Color darkBorder = Color(0xFF333333);

  // Light Theme Backgrounds & Surfaces
  static const Color lightBackground = Color(0xFFF6F6F6);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE8E8E8);

  // Text Colors
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFA0A0A0);
  static const Color textPrimaryLight = Color(0xFF121212);
  static const Color textSecondaryLight = Color(0xFF6B6B6B);

  // Status & Tracking Indicators
  static const Color passedStoppage = Color(0xFF05A357);
  static const Color currentStoppage = Color(0xFFFFC043);
  static const Color upcomingStoppage = Color(0xFF276EF1);
  static const Color inactiveStoppage = Color(0xFF757575);
}
