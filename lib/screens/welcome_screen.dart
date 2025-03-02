import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../utils/shared_preferences_helper.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  WelcomeScreenState createState() =>  WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
  }
  Future<void> _onAgreePressed() async {
    await SharedPreferencesHelper.setAgreementStatus(true);
    if(mounted){
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding:const EdgeInsets.all(30),
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/jnu.jpg'), // Local asset image
                fit: BoxFit.cover, // Adjusts the image to cover the container
              ),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Welcome to JnU Bus Routes Application",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 40,
                  fontStyle: FontStyle.italic
                ),
                ),
                ShadButton(
                  onPressed: _onAgreePressed,
                  backgroundColor: Colors.redAccent,
                  icon: const Icon(LucideIcons.handshake,),
                  width: 200,
                  height: 70,
                  child:  const Text(
                    "Agree",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,

                    ),

                  ),
                ),
                const Text("Click 'Agree' to continue",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
                      fontStyle: FontStyle.italic
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}