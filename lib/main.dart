import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jnu_bus_routes/database/database_helper.dart';
import 'package:jnu_bus_routes/providers/bus_provider.dart';
import 'package:jnu_bus_routes/providers/place_provider.dart';
import 'package:jnu_bus_routes/providers/route_provider.dart';
import 'package:jnu_bus_routes/providers/theme_provider.dart';
import 'package:jnu_bus_routes/utils/shared_preferences_helper.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool? hasAgreed = await SharedPreferencesHelper.getAgreementStatus();
  bool? isDarkMode = await SharedPreferencesHelper.getThemeStatus();
  Color bgColor = await SharedPreferencesHelper.getBgColor();
  String? busName = await SharedPreferencesHelper.getBusName();
  List<Map<String, dynamic>> routeList = [];
  if (busName != null && busName != "") {
    routeList = await DatabaseHelper().getBusInfo(busName: busName, busType: 1);
  }
  String? destinationOrSourceName =
      await SharedPreferencesHelper.getDestOrSource();
  List<Map<String, dynamic>> busListForDestination = [];
  if (destinationOrSourceName != null && destinationOrSourceName != "") {
    busListForDestination =
        await DatabaseHelper().getBusInfo(placeName: destinationOrSourceName);
  }
  if (isDarkMode == null) {
    isDarkMode = true;
    await SharedPreferencesHelper.setThemeStatus(true);
  }
  List<String> _placeList = await DatabaseHelper().getPlaceList();
  String initialLocation = hasAgreed == true ? '/' : '/welcome';
  runApp(
    ProviderScope(
      overrides: [
        isDarkTheme.overrideWith((ref) => isDarkMode!),
        backgroundColor.overrideWith((ref) => bgColor),
        placeListProvider.overrideWith((ref) => _placeList),
        busNameProvider.overrideWith((ref) => busName),
        destinationProvider.overrideWith((ref) => destinationOrSourceName),
        busListForDestinationProvider
            .overrideWith((ref) => busListForDestination),
        routeListProvider.overrideWith((ref) => routeList),
      ],
      child: MyApp(
        initialLocation: initialLocation,
      ),
    ),
  );

  //For development time...

//   runApp(
//     ProviderScope(
//       overrides: [
//         isDarkTheme.overrideWith((ref) => isDarkMode!),
//         backgroundColor.overrideWith((ref) => bgColor),
//         placeListProvider.overrideWith((ref) => _placeList),
//         busNameProvider.overrideWith((ref) => busName),
//         destinationProvider.overrideWith((ref) => destinationOrSourceName),
//         busListForDestinationProvider
//             .overrideWith((ref) => busListForDestination),
//         routeListProvider.overrideWith((ref) => routeList),
//       ],
//       child: const MyApp(
//         initialLocation: "/",
//       ),
//     ),
//   );
}

class MyApp extends ConsumerWidget {
  final String initialLocation;

  const MyApp({
    super.key,
    required this.initialLocation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkModeStatus = ref.watch(isDarkTheme);
    final GoRouter router = AppRouter(initialLocation: initialLocation).router;
    return ShadApp.materialRouter(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      themeMode: isDarkModeStatus ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
