import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isDarkTheme = StateProvider<bool>((ref) => true);
final backgroundColor = StateProvider<Color>((ref) => Colors.pinkAccent);
