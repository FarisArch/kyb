import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 201, 160),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 100, 100, 0),
                child: Text(
                  'Create Account',
                  style: TextStyle(fontSize: 35),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 90, 50),
                child: Text(
                  'Please sign-up to continue',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 350,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Full Name',
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                            filled: true,
                            fillColor: Colors.purple,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                          onSaved: (value) => _fullName = value!,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: 350,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                            filled: true,
                            fillColor: Colors.purple,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          onSaved: (value) => _email = value!,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: 350,
                        child: TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                            filled: true,
                            fillColor: Colors.purple,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                          onSaved: (value) => _password = value!,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: 350,
                        child: TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Confirm Password',
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                            filled: true,
                            fillColor: Colors.purple,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _password) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          onSaved: (value) => _confirmPassword = value!,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(240, 0, 0, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            // TODO: Handle form data
                            print('Full Name: $_fullName');
                            print('Email: $_email');
                            print('Password: $_password');
                            print('Confirm Password: $_confirmPassword');
                          }
                        },
                        child: Text('Sign up'),
                      ),
                    ),
                    Text('Already have an account? Sign in'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
