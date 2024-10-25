// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 201, 160),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 100, 250, 0),
              child: Text('Login', style: TextStyle(fontSize: 35)),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 100, 50),
              child: Text('Please sign-in to continue', style: TextStyle(fontSize: 20)),
            ),
            Center(
              child: Container(
                width: 350,
                child: TextFormField(
                  decoration: InputDecoration(hintText: 'Username', hintStyle: TextStyle(color: Colors.white), border: OutlineInputBorder(), prefixIcon: Icon(Icons.email), filled: true, fillColor: Colors.purple[900]),
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                width: 350,
                child: TextFormField(
                  obscureText: true,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.purple[900],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(200, 10, 0, 0),
              child: Text('Forgot your password?'),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(230, 0, 0, 0),
              child: Container(
                width: 130,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.login),
                        Text('Login',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            )),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
              child: Text('Dont have an account? Sign up!'),
            )
          ]),
        ),
      ),
    );
  }
}
