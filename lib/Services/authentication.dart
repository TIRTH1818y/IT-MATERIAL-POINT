import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Home_Screens_Pages/Home.dart';

class AuthServices extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthServices({super.key});

  BuildContext get context => context;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = "Some Error Occured.";
    try {
      if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        //add user firestore
        await _firestore.collection("Users").doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'uid': userCredential.user!.uid,
        });
        res = "success";
      } else {
        res = "Please Enter Required Fields.";
      }
    } on FirebaseException catch (e) {
      // print(e.toString());
      return e.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some Error Occured.";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email.toString().trim(),
            password: password.toString().trim());
        res = "success";
      } else {
        res = "Please Enter Required Fields.";
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          res = 'Invalid email format.';
          break;
        case 'ERROR_WRONG_PASSWORD':
          res = 'Incorrect password.';
          break;
        case 'ERROR_USER_DISABLED':
          res =  ' User Is Disabled.';
          break;
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          res = ' Email Already in Use.';
          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
          res =  ' Opeation Not allowed.';
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          res =  'To Many Requests Your Account Has Been Restricted Temporery.';
          break;
        default:
          ('An unexpected error occurred: ${e.message}');
      }

    }

    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential).then(
          (value) => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Home())));
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return const Column();
  }
}
