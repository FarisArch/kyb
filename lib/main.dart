// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kyb/pages/pages.dart'; // PUT ALL PAGES IN PAGES.DART
import 'package:firebase_core/firebase_core.dart';
import 'package:kyb/pages/report_wrongclass.dart';
import 'package:kyb/services/api_key.dart';

void main() {
  runFirebase();
  runApp(MaterialApp(
    initialRoute: '/report',
    routes: {
      '/': (context) => SplashScreen(),
      '/front': (context) => FrontPage(),
      '/login': (context) => LoginPage(),
      '/register': (context) => RegisterPage(),
      '/successfulContribute': (context) => SuccessfulContribute(),
      '/successfulReport': (context) => SuccessfulReport(),
      '/home': (context) => Home(),
      '/news': (context) => NewsPage(),
      '/scan': (context) => ScanPage(),
      '/search': (context) => SearchPage(),
      '/contribute': (context) => ContributePage(),
      '/report': (context) => ReportPage(),
      '/report_wrongcategory': (context) => ReportWrongCategory(),
      '/report_wrongclass': (context) => ReportWrongClass(),
      '/successful_report': (context) => SuccessfulReport(),
    },
  ));
}

void runFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(apiKey: firebase_api_key, appId: firebase_app_id, messagingSenderId: "138817668884", projectId: "know-your-business-fyp"));
}
