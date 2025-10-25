import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Memory Aid App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/reminders');
              },
              child: Text('Medication & Daily Reminders'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cognitive_exercises');
              },
              child: Text('Cognitive Exercises'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/recognition');
              },
              child: Text('Voice & Image Recognition'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/emergency_alert');
              },
              child: Text('Emergency Alerts'),
            ),
          ],
        ),
      ),
    );
  }
}
