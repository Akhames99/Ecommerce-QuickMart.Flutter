import 'package:ecommerce/Views/Pages/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
      home: CustomBottomNavbar(),
    );
  }
}
