import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jnu_bus_routes/providers/theme_provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../utils/shared_preferences_helper.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => WelcomeScreenState();
}

class WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _onAgreePressed() async {
    await SharedPreferencesHelper.setAgreementStatus(true);
    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = ref.watch(backgroundColorProvider);
    int stColor = bgColor.value;
    return Scaffold(
      body: SafeArea(
        child: Container(
            padding: const EdgeInsets.all(30),
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/jnu.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome to JnU Bus Routes Application",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 40,
                      fontStyle: FontStyle.italic),
                ),
                ShadButton(
                  onPressed: _onAgreePressed,
                  backgroundColor: Color(stColor),
                  size: ShadButtonSize.lg,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.handshake,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Agree",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  "Click 'Agree' to continue",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
                      fontStyle: FontStyle.italic),
                ),
              ],
            )),
      ),
    );
  }
}
