import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/screens/weather_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void>loadNextScreen()async{
    await Future.delayed(Duration(seconds: 5),(){
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>WeatherScreen()));
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNextScreen();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 186, 186, 187),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              LottieBuilder.asset('assets/smog.json',fit: BoxFit.cover,height: 900,)
            ],
          ),
        ),
      ),
    );
  }
}