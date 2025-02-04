import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:servicios_app/main_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:servicios_app/Screen/windgets/NotificationsService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _initHive();

  // Inicia la aplicación
  runApp(MyApp());
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  await Hive.openBox("login");
  await Hive.openBox("accounts");
}
