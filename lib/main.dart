import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jnu_bus_routes/providers/theme_provider.dart';
import 'package:jnu_bus_routes/utils/shared_preferences_helper.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool? hasAgreed = await SharedPreferencesHelper.getAgreementStatus();
  bool? isDarkMode = await SharedPreferencesHelper.getThemeStatus();
  if (isDarkMode == null) {
    isDarkMode = false;
    await SharedPreferencesHelper.setThemeStatus(false);
  }
  String initialLocation = hasAgreed == true ? '/' : '/welcome';
  runApp(
    ProviderScope(
      overrides: [isDarkTheme.overrideWith((ref) => isDarkMode!)],
      child: MyApp(
        initialLocation: initialLocation,
      ),
    ),
  );

  // //For development time...
  // runApp(const MyApp(initialLocation: "/"));
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
