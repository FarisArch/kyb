import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  bool _isLoading = false; // Track the loading state

  @override
  void initState() {
    super.initState();
    _checkIfUserIsSignedIn();
  }

  // Check if the user is already signed in
  void _checkIfUserIsSignedIn() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.isAnonymous) {
      // Navigate to home if already signed in as a guest
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/home');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 220, 80, 1),
      body: SafeArea(
        child: Column(
          children: [
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
                foregroundColor: const Color.fromARGB(240, 255, 220, 80),
                backgroundColor: Colors.white,
                minimumSize: Size(260, 60),
                textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              child: Text('Sign in'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(240, 255, 220, 80),
                backgroundColor: Colors.white,
                minimumSize: Size(260, 60),
                textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              child: Text('Create an account'),
            ),
            // SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: _isLoading
            //       ? null // Disable the button while loading
            //       : () async {
            //           setState(() {
            //             _isLoading = true; // Start loading
            //           });

            //           try {
            //             // Sign in as guest only if not already signed in
            //             final user = FirebaseAuth.instance.currentUser;
            //             if (user == null || !user.isAnonymous) {
            //               await FirebaseAuth.instance.signInAnonymously();
            //             }
            //             // Navigate to home once signed in
            //             WidgetsBinding.instance.addPostFrameCallback((_) {
            //               Navigator.pushReplacementNamed(context, '/home');
            //             });
            //           } catch (e) {
            //             print("Error signing in as guest: $e");
            //             ScaffoldMessenger.of(context).showSnackBar(
            //               SnackBar(content: Text('Error signing in as guest: $e')),
            //             );
            //           } finally {
            //             setState(() {
            //               _isLoading = false; // Stop loading after the sign-in process
            //             });
            //           }
            //         },
            //   style: ElevatedButton.styleFrom(
            //     foregroundColor: const Color.fromARGB(240, 255, 220, 80),
            //     backgroundColor: Colors.white,
            //     minimumSize: Size(260, 60),
            //     textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            //   ),
            //   child: _isLoading
            //       ? CircularProgressIndicator(
            //           valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
            //         )
            //       : Text('Guest Mode'),
            // ),
          ],
        ),
      ),
    );
  }
}
