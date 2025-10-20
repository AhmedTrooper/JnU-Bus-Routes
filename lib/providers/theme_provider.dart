import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Theme providers with proper naming
final isDarkThemeProvider = StateProvider<bool>((ref) => true);
final backgroundColorProvider = StateProvider<Color>((ref) => const Color(0xfff50057));
