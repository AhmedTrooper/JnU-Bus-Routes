import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.pitchBlack,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.uberBlue,
        secondary: AppColors.uberGold,
        surface: AppColors.uberDarkCard,
        onSurface: AppColors.textPrimary,
        onPrimary: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: AppColors.uberDarkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.uberBorder, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.pitchBlack,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.uberDarkCard,
        modalBackgroundColor: AppColors.uberDarkCard,
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dividerColor: AppColors.uberBorder,
    );
  }

  static ThemeData get lightTheme {
    return darkTheme; // Default to signature dark mode for luxury Uber aesthetic
  }
}
