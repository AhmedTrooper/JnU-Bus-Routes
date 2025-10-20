import 'package:flutter_riverpod/flutter_riverpod.dart';

final busNameProvider = StateProvider<String?>((ref) => null);
final busListForDestinationProvider =
    StateProvider<List<Map<String, dynamic>>>((ref) => []);
