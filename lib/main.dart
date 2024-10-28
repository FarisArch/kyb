import 'package:flutter/material.dart';
import 'package:kyb/pages/pages.dart';
import 'package:kyb/pages/successful_contribute.dart';
import 'package:kyb/pages/successful_login.dart';
import 'package:kyb/pages/successful_register.dart';
import 'package:kyb/pages/successful_report.dart';// PUT ALL PAGES IN PAGES.DART

void main() => runApp(MaterialApp(initialRoute: '/successfulReport', routes: {
  '/': (context) => SplashScreen(),
  '/front': (context) => FrontPage(),
  '/login': (context) => LoginPage(),
  '/register': (context) => RegisterPage(),
  '/successfulLogin': (context) => SuccessfulLogin(),
  '/successfulRegister': (context) => SuccessfulRegister(),
  '/successfulContribute': (context) => SuccessfulContribute(),
  '/successfulReport': (context) => SuccessfulReport()
}));