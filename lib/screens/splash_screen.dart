import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/shared_preferences_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAgreement();
  }

  Future<void> _checkAgreement() async {
    bool? agreed = await SharedPreferencesHelper.getAgreementStatus();
    if (mounted) {
      context.go(agreed == true ? '/' : '/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Container(
          padding:const EdgeInsets.all(30),
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/jnu.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: const Text(""),
        ),
      ),
    );
  }
}
