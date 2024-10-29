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
      backgroundColor: const Color.fromRGBO(255, 220, 80, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 100, 250, 0),
              child: Text('Login', style: TextStyle(fontSize: 35, color: Colors.white)),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 100, 50),
              child: Text('Please sign-in to continue', style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
            Center(
              child: Container(
                width: 350,
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Username',
                      hintStyle: TextStyle(color: Color.fromRGBO(255, 220, 80, 1)),
                      prefixIcon: Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.white),
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
                      hintStyle: TextStyle(color: Color.fromRGBO(255, 220, 80, 1)),
                      prefixIcon: Icon(Icons.key),
                      filled: true,
                      fillColor: Colors.white),
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
            SizedBox(height: 30),
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
