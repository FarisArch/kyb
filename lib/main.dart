import 'package:flutter/material.dart';
import 'package:kyb/pages/front.dart';
import 'package:kyb/pages/splash.dart';
import 'package:kyb/pages/login.dart';
import 'package:kyb/pages/register.dart';

void main() => runApp(MaterialApp(initialRoute: '/register', routes: {
      '/': (context) => SplashScreen(),
      '/front': (context) => FrontPage(),
      '/login': (context) => LoginPage(),
      '/register': (context) => RegisterPage()
    }));
