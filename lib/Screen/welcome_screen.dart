import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servicios_app/Screen/home_screen.dart';
import 'package:servicios_app/Screen/login/login_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final Box _boxLogin = Hive.box("login");

  @override
  void initState() {
    super.initState();

    // Inicia un temporizador que navegará al HomeScreen después de 3 segundos
    Future.delayed(Duration(seconds: 3), () {
      _navigateToHomeScreen();
    });
  }

  // Función para navegar al HomeScreen y limpiar el estado de inicio de sesión
  void _navigateToHomeScreen() {
    _boxLogin.clear();
    _boxLogin.put("loginStatus", false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return HomeScreen(); // Reemplaza HomeScreen con el nombre correcto de tu pantalla principal.
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
          decoration: BoxDecoration(
            color: Color(0xFFFAFAFF),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Taskers MX",
                textAlign: TextAlign.center,
                style: GoogleFonts.lobster(
                  fontSize: 60,
                  color: Color(0xFF1E2749),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 20),
              IconButton(
                onPressed: () {
                  _boxLogin.clear();
                  _boxLogin.put("loginStatus", false);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Login();
                      },
                    ),
                  );
                },
                icon: Icon(Icons.logout_rounded),
                color: Color(0xFFFAFAFF),
              ),
              SizedBox(height: 20),
              Text(
                "¿Buscas ayuda de algún profesional?, encuéntralo en Taskers MX",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF1E2749).withOpacity(0.8),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 20),
              Image.asset(
                "images/fondowelcome.png",
                width: 325,
                height: 325,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
