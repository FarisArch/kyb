// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kyb/services/auth_service.dart';

import '../auth/forgot_pass.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 220, 80, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 100, 250, 0),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 35, color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 100, 50),
                child: Text(
                  'Please sign-in to continue',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              Center(
                child: Container(
                  width: 350,
                  child: TextFormField(
                    controller: _emailController, // Assign the controller here
                    decoration: InputDecoration(
                      hintText: 'Username',
                      hintStyle: TextStyle(color: Color.fromRGBO(255, 220, 80, 1)),
                      prefixIcon: Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.white,
                    ),
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
                    controller: _passwordController, // Assign the controller here
                    obscureText: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Color.fromRGBO(255, 220, 80, 1)),
                      prefixIcon: Icon(Icons.key),
                      filled: true,
                      fillColor: Colors.white,
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
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPassword()),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.white, // Match text color to the rest of the theme
                        fontSize: 16, // Adjust font size for better readability
                      ),
                    ),
                  ),
                  SizedBox(width: 15), // Add padding to prevent it from sticking to the edge
                ],
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.fromLTRB(230, 0, 0, 0),
                child: Container(
                  width: 130,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                    onPressed: () async {
                      AuthenticationService().login(
                        email: _emailController.text, // Use the controller's text here
                        password: _passwordController.text, // Use the controller's text here
                        context: context,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.login),
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to register.dart
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    'Don’t have an account? Sign up!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
