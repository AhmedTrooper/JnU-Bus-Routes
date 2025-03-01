import 'dart:ffi';

import 'package:go_router/go_router.dart';
import 'package:jnu_bus_routes/screens/bus_details.dart';
import '../screens/home_screen.dart';
import '../screens/welcome_screen.dart';

class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      initialLocation: "/welcome",
      routerNeglect: false,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/welcome',
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: '/bus/:busName', // Dynamic route with :id parameter
          builder: (context, state) {
            // Extract the 'id' parameter from the state
            final String busName = state.pathParameters['busName']!;
            return BusDetailsScreen(busName: busName,upOrDown: 1,);
          },
        ),
        GoRoute(
          path: '/bus/:busName/:upOrDown', // Dynamic route with :id parameter
          builder: (context, state) {
            // Extract the 'id' parameter from the state
            final String busName = state.pathParameters['busName']!;
            final int upOrDown = int.tryParse(state.pathParameters['upOrDown']!) ?? 1;
            return BusDetailsScreen(busName: busName,upOrDown: upOrDown,);
          },
        ),
      ],
    );
  }
}