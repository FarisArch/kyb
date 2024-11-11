import 'package:flutter/material.dart';
import 'package:kyb/pages/home.dart';

class SuccessfulContribute extends StatelessWidget {
  const SuccessfulContribute ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 220, 80, 1), // Original background color
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 100, color: Colors.green), // Celebration icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  'Your suggestion was successfully submitted!',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.green, // Green color for the title
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Thank you for your contribution.',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
              child: Text('Continue'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded button
                ),
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Placeholder for the dashboard
class DashboardContribute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }
}
