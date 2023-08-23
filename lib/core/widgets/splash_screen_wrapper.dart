import 'package:flutter/material.dart';
import 'package:omni_dent/core/screens/home_screen.dart';
import 'package:omni_dent/core/screens/my_home_page.dart';
import 'package:omni_dent/core/screens/splash_screen.dart';

class SplashScreenWrapper extends StatefulWidget {
  @override
  _SplashScreenWrapperState createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  @override
  void initState() {
    super.initState();
    _loadSplashScreen();
  }

  _loadSplashScreen() async {
    await Future.delayed(
        Duration(seconds: 3)); // Replace with your desired duration
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              HomeScreen()), // Replace with your main content screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
