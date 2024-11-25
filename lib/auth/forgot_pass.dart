import 'package:flutter/material.dart';
import 'package:kyb/auth/auth_service.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _auth = AuthService();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 220, 80, 1), // Match background color
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 220, 80, 1),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white, // Match heading text color
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter your email to receive a password reset link",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Match subheading text color
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _email,
                decoration: const InputDecoration(
                  hintText: "Enter email",
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(255, 220, 80, 1), // Match hint text color
                  ),
                  labelText: "Email",
                  labelStyle: TextStyle(
                    color: Colors.black, // Label color for better contrast
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.black), // Add icon to match login.dart
                  filled: true,
                  fillColor: Colors.white, // Match input field background color
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 130,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink, // Match button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        await _auth.sendPasswordReset(_email.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "An email for password reset has been sent to your email.",
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error: $e"),
                          ),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(width: 7),
                        Text(
                          "Send Email",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
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
