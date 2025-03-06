import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jnu_bus_routes/utils/shared_preferences_helper.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool? hasAgreed = await SharedPreferencesHelper.getAgreementStatus();
  String initialLocation = hasAgreed == true ? '/' : '/welcome';
  runApp(MyApp(initialLocation: initialLocation));


  // //For development time...
  // runApp(const MyApp(initialLocation: "/"));
}

class MyApp extends StatelessWidget {
  final String initialLocation;
   const MyApp({super.key,required this.initialLocation});
  @override
  Widget build(BuildContext context) {
    final GoRouter router = AppRouter(initialLocation: initialLocation).router;
    return ShadApp.materialRouter(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}