import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:kyb/pages/pages.dart';

class AuthenticationService {
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.updateDisplayName(name);
      String message = 'Account created successfully!';
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'weak-password') {
        message = 'Password is weak';
      } else if (e.code == 'email-in-use') {
        message = 'An account already exists with that email!';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      throw Exception(message);
    } catch (e) {}
  }

  Future<void> login({required String email, required String password, required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      String message = 'Login successfully!';
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'Wrong email or password.';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong email or password.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {}
  }
}
