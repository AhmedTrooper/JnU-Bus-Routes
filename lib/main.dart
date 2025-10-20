import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:jnu_bus_routes/database/database_helper.dart';
import 'package:jnu_bus_routes/providers/bus_provider.dart';
import 'package:jnu_bus_routes/providers/place_provider.dart';
import 'package:jnu_bus_routes/providers/route_provider.dart';
import 'package:jnu_bus_routes/providers/theme_provider.dart';
import 'package:jnu_bus_routes/routes/app_router.dart';
import 'package:jnu_bus_routes/utils/shared_preferences_helper.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  // Preserve splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    // Load initial data from SharedPreferences
    final hasAgreed = await SharedPreferencesHelper.getAgreementStatus() ?? false;
    final isDarkMode = await SharedPreferencesHelper.getThemeStatus() ?? true;
    final bgColor = await SharedPreferencesHelper.getBgColor();
    final busName = await SharedPreferencesHelper.getBusName();
    final destinationOrSourceName = await SharedPreferencesHelper.getDestOrSource();

    // Initialize database and load data
    final dbHelper = DatabaseHelper();
    final placeList = await dbHelper.getPlaceList();
    
    // Load bus route data if bus name is selected
    final routeList = (busName != null && busName.isNotEmpty)
        ? await dbHelper.getBusInfo(busName: busName, busType: 1)
        : <Map<String, dynamic>>[];

    // Load bus list for destination if selected
    final busListForDestination = (destinationOrSourceName != null && destinationOrSourceName.isNotEmpty)
        ? await dbHelper.getBusInfo(placeName: destinationOrSourceName)
        : <Map<String, dynamic>>[];

    // Determine initial route
    final initialLocation = hasAgreed ? '/' : '/welcome';

    runApp(
      ProviderScope(
        child: MyApp(
          initialLocation: initialLocation,
          isDarkMode: isDarkMode,
          bgColor: bgColor,
          placeList: placeList,
          busName: busName,
          destinationOrSourceName: destinationOrSourceName,
          busListForDestination: busListForDestination,
          routeList: routeList,
        ),
      ),
    );
  } catch (e) {
    // Fallback in case of initialization error
    debugPrint('Error during initialization: $e');
    runApp(
      ProviderScope(
        child: MyApp(
          initialLocation: '/welcome',
          isDarkMode: true,
          bgColor: const Color(0xfff50057),
          placeList: const [],
          busName: null,
          destinationOrSourceName: null,
          busListForDestination: const [],
          routeList: const [],
        ),
      ),
    );
  }
}

class MyApp extends ConsumerStatefulWidget {
  final String initialLocation;
  final bool isDarkMode;
  final Color bgColor;
  final List<String> placeList;
  final String? busName;
  final String? destinationOrSourceName;
  final List<Map<String, dynamic>> busListForDestination;
  final List<Map<String, dynamic>> routeList;

  const MyApp({
    super.key,
    required this.initialLocation,
    required this.isDarkMode,
    required this.bgColor,
    required this.placeList,
    this.busName,
    this.destinationOrSourceName,
    required this.busListForDestination,
    required this.routeList,
  });

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize providers with loaded data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(isDarkThemeProvider.notifier).state = widget.isDarkMode;
      ref.read(backgroundColorProvider.notifier).state = widget.bgColor;
      ref.read(placeListProvider.notifier).state = widget.placeList;
      ref.read(filteredPlaceListProvider.notifier).state = widget.placeList;
      if (widget.busName != null) {
        ref.read(busNameProvider.notifier).state = widget.busName;
      }
      if (widget.destinationOrSourceName != null) {
        ref.read(destinationProvider.notifier).state = widget.destinationOrSourceName;
      }
      ref.read(busListForDestinationProvider.notifier).state = widget.busListForDestination;
      ref.read(routeListProvider.notifier).state = widget.routeList;
      
      // Remove splash screen after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        FlutterNativeSplash.remove();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(isDarkThemeProvider);
    final router = AppRouter(initialLocation: widget.initialLocation).router;

    return ShadApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: ShadColorScheme.fromName('slate', brightness: Brightness.light),
      ),
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: ShadColorScheme.fromName('slate', brightness: Brightness.dark),
      ),
    );
  }
}
