import 'package:flutter/material.dart';
import 'package:servicios_app/Screen/login/login_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFAFAFF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF212325),
          //Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      home: const Login(),
    );
  }
}
