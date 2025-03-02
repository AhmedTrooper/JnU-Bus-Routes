import 'package:go_router/go_router.dart';
import 'package:jnu_bus_routes/screens/bus_details.dart';
import 'package:jnu_bus_routes/screens/place_details.dart';
import 'package:jnu_bus_routes/screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/welcome_screen.dart';

class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      initialLocation: "/splash",
      routerNeglect: false,
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/welcome',
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: '/bus/:busName/:upOrDown',
          builder: (context, state) {

            final String busName = state.pathParameters['busName']!;
            final int upOrDown = int.tryParse(state.pathParameters['upOrDown']!) ?? 1;
            return BusDetailsScreen(busName: busName,upOrDown: upOrDown,);
          },
        ),
        GoRoute(
          path: '/place/:placeName',
          builder: (context, state) {
            final String placeName = state.pathParameters['placeName']!;
            return PlaceDetailsScreen(placeName: placeName,);
          },
        ),
      ],
    );
  }
}