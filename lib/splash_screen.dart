import 'dart:async';
import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'weather_info_screen.dart';

class splashScreen extends StatefulWidget {
  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.fadeIn(
      backgroundColor: Colors.white,
      childWidget: SizedBox(
        height: 200,
        width: 200,
        child: Image.asset("assets/images/weather.png"),
      ),
      onAnimationEnd: () => debugPrint("On Fade In End"),
      asyncNavigationCallback: () async {
        await Future.delayed(const Duration(milliseconds: 2000));
      },
      nextScreen: WeatherPage(),
    );
  }
}
