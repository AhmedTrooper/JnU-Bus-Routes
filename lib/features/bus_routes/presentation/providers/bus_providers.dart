import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/hive_service.dart';
import '../../../../core/utils/location_helper.dart';
import '../../../../core/utils/url_parser.dart';
import '../../data/models/bus_model.dart';
import '../../data/repositories/bus_repository.dart';
import '../../domain/models/bus_enums.dart';
import '../../domain/models/route_stoppage.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final busRepositoryProvider = Provider<BusRepository>((ref) {
  final dbHelper = ref.watch(appDatabaseProvider);
  return BusRepository(dbHelper);
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedUserTypeFilterProvider = StateProvider<UserType?>((ref) => null);

final allBusesProvider = FutureProvider<List<BusModel>>((ref) async {
  final repo = ref.watch(busRepositoryProvider);
  return repo.getAllBuses();
});

enum BusSortMode { name, upTime, downTime }

final busSortModeProvider = StateProvider<BusSortMode>((ref) => BusSortMode.name);

final filteredBusesProvider = FutureProvider<List<BusModel>>((ref) async {
  final repo = ref.watch(busRepositoryProvider);
  final query = ref.watch(searchQueryProvider);
  final selectedFilter = ref.watch(selectedUserTypeFilterProvider);
  final sortMode = ref.watch(busSortModeProvider);

  List<BusModel> buses = await repo.searchBuses(query);

  if (selectedFilter != null) {
    buses = buses.where((b) => b.userType == selectedFilter).toList();
  }

  // Apply sorting
  buses.sort((a, b) {
    switch (sortMode) {
      case BusSortMode.name:
        return a.busName.compareTo(b.busName);
      case BusSortMode.upTime:
        return a.upTime.compareTo(b.upTime);
      case BusSortMode.downTime:
        return a.downTime.compareTo(b.downTime);
    }
  });

  return buses;
});

final busDetailProvider = FutureProvider.family<BusModel?, int>((ref, busId) async {
  final repo = ref.watch(busRepositoryProvider);
  return repo.getBusById(busId);
});

/// Route stoppages enriched with coordinates and live passed/upcoming status
final busRouteStoppagesProvider = FutureProvider.family
    .autoDispose<List<RouteStoppage>, ({int busId, RouteDirection direction, LatLng? userLocation, int? activeIndex})>(
        (ref, arg) async {
  final repo = ref.watch(busRepositoryProvider);
  final bus = await repo.getBusById(arg.busId);
  final rawStoppages = await repo.getStoppagesForBus(arg.busId, arg.direction);

  if (bus == null) return rawStoppages;

  // Extract direction URL
  final dirUrl = (arg.direction == RouteDirection.up) ? bus.upDirUrl : bus.downDirUrl;
  final routePoints = UrlParser.parseDirectionsUrl(dirUrl);

  // Attach coordinates to stoppages
  final stoppagesWithCoords = LocationHelper.attachCoordinatesToStoppages(rawStoppages, routePoints);

  // Compute passed vs upcoming statuses
  return LocationHelper.computeStoppageStatuses(
    stoppagesWithCoords,
    userLocation: arg.userLocation,
    activeIndex: arg.activeIndex,
  );
});

/// Raw route polyline points extracted from Google directions URL in bus model
final busRoutePolylineProvider = FutureProvider.family
    .autoDispose<List<LatLng>, ({int busId, RouteDirection direction})>((ref, arg) async {
  final repo = ref.watch(busRepositoryProvider);
  final bus = await repo.getBusById(arg.busId);
  if (bus == null) return [];

  final dirUrl = (arg.direction == RouteDirection.up) ? bus.upDirUrl : bus.downDirUrl;
  return UrlParser.parseDirectionsUrl(dirUrl);
});

/// Favorites StateNotifier
class FavoritesNotifier extends StateNotifier<List<int>> {
  FavoritesNotifier() : super(HiveService.favoriteBusIds);

  Future<void> toggle(int busId) async {
    await HiveService.toggleFavorite(busId);
    state = HiveService.favoriteBusIds;
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<int>>((ref) {
  return FavoritesNotifier();
});
