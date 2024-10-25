import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 201, 160),
      body: SafeArea(
          child: Column(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 200, 0, 0),
          child: Center(
            child: Text(
              'KYB',
              style: TextStyle(
                fontSize: 80,
                color: Colors.purple[900],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Text(
          'Know Your Business',
          style: TextStyle(fontSize: 35, color: Colors.purple[900]),
        )
      ])),
    );
  }
}
