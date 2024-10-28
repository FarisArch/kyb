import 'package:flutter/material.dart';
import 'package:kyb/pages/pages.dart'; // PUT ALL PAGES IN PAGES.DART

void main() => runApp(MaterialApp(initialRoute: '/front', routes: {
  '/': (context) => SplashScreen(),
  '/front': (context) => FrontPage(),
  '/login': (context) => LoginPage(),
  '/register': (context) => RegisterPage(),
  '/successfulLogin': (context) => SuccessfulLogin(),
  '/successfulRegister': (context) => SuccessfulRegister(),
  '/successfulContribute': (context) => SuccessfulContribute(),
  '/successfulReport': (context) => SuccessfulReport()
}));