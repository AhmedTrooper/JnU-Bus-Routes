import 'package:flutter_riverpod/flutter_riverpod.dart';

final placeListProvider = StateProvider<List<String>>((ref) => []);
final filteredPlaceListProvider = StateProvider<List<String>>((ref) => []);
final destinationProvider = StateProvider<String?>((ref) => null);
final placeListForSingleBusProvider = StateProvider<List<String>>((ref) => []);
