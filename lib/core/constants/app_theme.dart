import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkForeground,
        secondary: AppColors.shadcnBlue,
        surface: AppColors.darkCard,
        onSurface: AppColors.darkForeground,
        onPrimary: AppColors.darkBackground,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkBorder, width: 1.0),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.darkForeground,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.4,
        ),
        iconTheme: IconThemeData(color: AppColors.darkForeground),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkCard,
        modalBackgroundColor: AppColors.darkCard,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: AppColors.darkForeground, fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: -0.5),
        titleLarge: TextStyle(color: AppColors.darkForeground, fontWeight: FontWeight.w600, fontSize: 18, letterSpacing: -0.4),
        titleMedium: TextStyle(color: AppColors.darkForeground, fontWeight: FontWeight.w600, fontSize: 16),
        bodyLarge: TextStyle(color: AppColors.darkForeground, fontSize: 14),
        bodyMedium: TextStyle(color: AppColors.darkMutedForeground, fontSize: 13),
        labelSmall: TextStyle(color: AppColors.darkMutedForeground, fontSize: 11, fontWeight: FontWeight.w500),
      ),
      dividerColor: AppColors.darkBorder,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightForeground,
        secondary: AppColors.shadcnBlue,
        surface: AppColors.lightCard,
        onSurface: AppColors.lightForeground,
        onPrimary: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 1,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightBorder, width: 1.0),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.lightForeground,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.4,
        ),
        iconTheme: IconThemeData(color: AppColors.lightForeground),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightCard,
        modalBackgroundColor: AppColors.lightCard,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: AppColors.lightForeground, fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: -0.5),
        titleLarge: TextStyle(color: AppColors.lightForeground, fontWeight: FontWeight.w600, fontSize: 18, letterSpacing: -0.4),
        titleMedium: TextStyle(color: AppColors.lightForeground, fontWeight: FontWeight.w600, fontSize: 16),
        bodyLarge: TextStyle(color: AppColors.lightForeground, fontSize: 14),
        bodyMedium: TextStyle(color: AppColors.lightMutedForeground, fontSize: 13),
        labelSmall: TextStyle(color: AppColors.lightMutedForeground, fontSize: 11, fontWeight: FontWeight.w500),
      ),
      dividerColor: AppColors.lightBorder,
    );
  }
}
