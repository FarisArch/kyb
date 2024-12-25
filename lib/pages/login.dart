// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // Function to check if the user is an admin
  Future<bool> _checkIfAdmin() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final idTokenResult = await user.getIdTokenResult();
      final claims = idTokenResult.claims;

      // Check if 'admin' claim is true
      return claims != null && claims['admin'] == true;
    }

    return false;
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
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      hintStyle: TextStyle(color: Color.fromRGBO(255, 220, 80, 1)),
                      prefixIcon: Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 350,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Color.fromRGBO(255, 220, 80, 1)),
                      prefixIcon: Icon(Icons.key),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
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
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
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
                      try {
                        // Attempt to log in the user
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        );

                        // Once logged in, fetch the user
                        final user = FirebaseAuth.instance.currentUser;

                        if (user != null) {
                          // Force token refresh to get updated claims
                          await user.getIdToken(true);
                          final idTokenResult = await user.getIdTokenResult();

                          // Check if the user has admin claims
                          final isAdmin = idTokenResult.claims?['isAdmin'] ?? false;

                          if (isAdmin) {
                            // Redirect admin users to admin dashboard
                            Navigator.pushReplacementNamed(context, '/admin_dashboard');
                          } else {
                            // Redirect regular users to home page
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        }
                      } on FirebaseAuthException catch (e) {
                        // Handle login errors properly
                        String errorMessage;

                        if (e.code == 'user-not-found') {
                          errorMessage = 'No user found with this email.';
                        } else if (e.code == 'wrong-password') {
                          errorMessage = 'Wrong password provided.';
                        } else {
                          errorMessage = 'Login failed. Please try again.';
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage)),
                        );
                      } catch (e) {
                        // Catch any unexpected errors
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('An error occurred: ${e.toString()}')),
                        );
                      }
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
