import 'package:ecommerce/Utils/app_router.dart';
import 'package:ecommerce/Utils/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce App',
      theme: ThemeData(
        fontFamily: "Coolvetica",
        primaryColor: Color(0xFF005A32),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: AppRoutes.homeRoute,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
