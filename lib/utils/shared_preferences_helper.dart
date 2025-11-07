import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Helper class for managing SharedPreferences operations
class SharedPreferencesHelper {
  static const String _keyHasAgreed = 'hasAgreed';
  static const String _userName = 'userName';
  static const String _busName = 'busName';
  static const String _destOrSource = 'destOrSource';
  static const String _isDarkMode = 'isDarkMode';
  static const String _bgColor = 'bgColor';

  // Agreement Status
  static Future<bool?> getAgreementStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyHasAgreed);
    } catch (e) {
      debugPrint('Error getting agreement status: $e');
      return null;
    }
  }

  static Future<void> setAgreementStatus(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyHasAgreed, value);
    } catch (e) {
      debugPrint('Error setting agreement status: $e');
    }
  }

  // User Name
  static Future<String?> getUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userName);
    } catch (e) {
      debugPrint('Error getting user name: $e');
      return null;
    }
  }

  static Future<void> setUserName(String userName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userName, userName);
    } catch (e) {
      debugPrint('Error setting user name: $e');
    }
  }

  // Bus Name
  static Future<String?> getBusName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_busName);
    } catch (e) {
      debugPrint('Error getting bus name: $e');
      return null;
    }
  }

  static Future<void> setBusName(String busName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_busName, busName);
    } catch (e) {
      debugPrint('Error setting bus name: $e');
    }
  }

  // Destination or Source
  static Future<String?> getDestOrSource() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_destOrSource);
    } catch (e) {
      debugPrint('Error getting destination/source: $e');
      return null;
    }
  }

  static Future<void> setDestOrSource(String stoppageName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_destOrSource, stoppageName);
    } catch (e) {
      debugPrint('Error setting destination/source: $e');
    }
  }

  // Theme Status
  static Future<bool?> getThemeStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isDarkMode);
    } catch (e) {
      debugPrint('Error getting theme status: $e');
      return null;
    }
  }

  static Future<void> setThemeStatus(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isDarkMode, value);
    } catch (e) {
      debugPrint('Error setting theme status: $e');
    }
  }

  // Background Color
  static Future<Color> getBgColor() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final colorValue = prefs.getInt(_bgColor);
      return Color(colorValue ?? const Color(0xfff50057).value);
    } catch (e) {
      debugPrint('Error getting background color: $e');
      return const Color(0xfff50057);
    }
  }

  static Future<void> setBgColor(Color color) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_bgColor, color.value);
    } catch (e) {
      debugPrint('Error setting background color: $e');
    }
  }

  // Clear all preferences
  static Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      debugPrint('Error clearing preferences: $e');
    }
  }
}
