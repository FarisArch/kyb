import 'package:flutter/material.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 220, 80, 1),
      body: SafeArea(
          child: Column(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
          child: Center(
            child: Text(
              'KYB',
              style: TextStyle(
                fontSize: 120,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Text(
          'Know Your Business',
          style: TextStyle(fontSize: 25, color: Colors.white, letterSpacing: 2.5),
        ),
        SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color.fromARGB(240, 255, 220, 80), // Set the text color to your specific yellow
            backgroundColor: Colors.white, // Set the button's background color
            minimumSize: Size(260, 60), // Set the minimum size of the button
            textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), // Set the text style
          ),
          child: Text('Sign in'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color.fromARGB(240, 255, 220, 80), // Set the text color to your specific yellow
            backgroundColor: Colors.white, // Set the button's background color
            minimumSize: Size(260, 60), // Set the minimum size of the button
            textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), // Set the text style
          ),
          child: Text('Create an account'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color.fromARGB(240, 255, 220, 80), // Set the text color to your specific yellow
            backgroundColor: Colors.white, // Set the button's background color
            minimumSize: Size(260, 60), // Set the minimum size of the button
            textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), // Set the text style
          ),
          child: Text('Guest Mode'),
        ),
        Row(
          children: [],
        )
      ])),
    );
  }
}
