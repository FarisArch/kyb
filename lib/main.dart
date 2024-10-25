import 'package:flutter/material.dart';
import 'package:kyb/pages/pages.dart'; // PUT ALL PAGES IN PAGES.DART

void main() => runApp(MaterialApp(initialRoute: '/register', routes: {
      '/': (context) => SplashScreen(),
      '/front': (context) => FrontPage(),
      '/login': (context) => LoginPage(),
      '/register': (context) => RegisterPage()
    }));
