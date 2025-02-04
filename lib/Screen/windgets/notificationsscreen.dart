import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  final String? title;
  final String? body;

  NotificationsScreen({this.title, this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? 'Sin título',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              body ?? 'Sin contenido',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
