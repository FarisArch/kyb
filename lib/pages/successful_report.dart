import 'package:flutter/material.dart';

class SuccessfulReport extends StatelessWidget {
  const SuccessfulReport ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 201, 160), // Original background color
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 100, color: Colors.green), // Celebration icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  'Your report was successfully submitted!',
                  style: TextStyle(
                    fontSize: 40,
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
                  fontSize: 20,
                  color: Colors.purple[900],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => DashboardReport()),
                );
              },
              child: Text('Continue'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded button
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Placeholder for the dashboard
class DashboardReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }
}