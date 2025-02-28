// lib/main.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'routes/app_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  final GoRouter _router = AppRouter().router;

  @override
  Widget build(BuildContext context) {
    return ShadApp.materialRouter(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,

    );
  }
}