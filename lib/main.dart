// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kyb/pages/admin_dashboard.dart';
import 'package:kyb/pages/pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kyb/services/api_key.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: firebase_api_key,
      appId: firebase_app_id,
      messagingSenderId: "138817668884",
      projectId: "know-your-business-fyp",
    ),
  );

  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true,
  );

  runApp(
    MaterialApp(
      initialRoute: '/admin_dashboard',
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
        '/report': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ReportPage(companyName: args['companyName']); // Pass companyName
        },
        '/report_wrongcategory': (context) => ReportWrongCategory(
              companyName: '',
            ),
        '/report_wrongclass': (context) => ReportWrongClass(
              companyName: '',
            ),
        /*'/report_misinfo': (context) => ReportWrongInfo(),*/
        '/admin_dashboard': (context) => AdminDashboardPage(),
        '/admin_new_brand': (context) => AdminContributePage(),
        '/admin_view_reports': (context) => AdminBrandsReport(),
        '/admin_update_brand': (context) => AdminBrandsUpdate(),
        '/admin_approval': (context) => AdminApprovalPage(),
      },
    ),
  );
}
