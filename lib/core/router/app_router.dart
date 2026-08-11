import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/bus_routes/domain/models/bus_enums.dart';
import '../../features/bus_routes/presentation/screens/bus_detail_screen.dart';
import '../../features/bus_routes/presentation/screens/bus_list_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/tracking_map/presentation/screens/live_map_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const BusListScreen(),
    ),
    GoRoute(
      path: '/bus/:id',
      name: 'busDetail',
      builder: (context, state) {
        final idStr = state.pathParameters['id'];
        final busId = int.tryParse(idStr ?? '') ?? 1;
        return BusDetailScreen(busId: busId);
      },
    ),
    GoRoute(
      path: '/bus/:id/map',
      name: 'liveMap',
      builder: (context, state) {
        final idStr = state.pathParameters['id'];
        final busId = int.tryParse(idStr ?? '') ?? 1;
        final dirStr = state.uri.queryParameters['direction'];
        final direction = (dirStr == 'down') ? RouteDirection.down : RouteDirection.up;
        return LiveMapScreen(busId: busId, initialDirection: direction);
      },
    ),
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.error}'),
    ),
  ),
);
