// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kyb/pages/pages.dart'; // PUT ALL PAGES IN PAGES.DART
import 'package:firebase_core/firebase_core.dart';

void main() {
  runFirebase();
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/': (context) => SplashScreen(),
      '/front': (context) => FrontPage(),
      '/login': (context) => LoginPage(),
      '/register': (context) => RegisterPage(),
      '/successfulLogin': (context) => SuccessfulLogin(),
      '/successfulRegister': (context) => SuccessfulRegister(),
      '/successfulContribute': (context) => SuccessfulContribute(),
      '/successfulReport': (context) => SuccessfulReport(),
      '/home': (context) => Home(),
      '/news': (context) => NewsPage(),
      '/scan': (context) => ScanPage(),
    },
  ));
}

void runFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}
