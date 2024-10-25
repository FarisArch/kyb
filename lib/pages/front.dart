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
      backgroundColor: const Color.fromARGB(255, 236, 201, 160),
      body: SafeArea(
          child: Column(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: Center(
            child: Text(
              'KYB',
              style: TextStyle(
                fontSize: 80,
                color: Colors.purple[900],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Text(
          'Know Your Business',
          style: TextStyle(fontSize: 35, color: Colors.purple[900]),
        ),
        SizedBox(height: 50),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            minimumSize: Size(200, 60), // Set the minimum size of the button
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Set the text style
          ),
          child: Text('Sign in'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            minimumSize: Size(200, 60), // Set the minimum size of the button
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Set the text style
          ),
          child: Text('Create an account'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            minimumSize: Size(200, 60), // Set the minimum size of the button
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Set the text style
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
