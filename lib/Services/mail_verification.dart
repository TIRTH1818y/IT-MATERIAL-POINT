import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:itmaterialspoint/Login_Register/Login.dart';
import 'package:itmaterialspoint/UI_widgets/elevated.dart';
import 'package:itmaterialspoint/UI_widgets/snack_bar.dart';

import '../Home_Screens_Pages/Home.dart';

class verifyEmail extends StatefulWidget {
  final name;
  final email;
  final password;
  final phone;
  final File? pickedImage;
  final fromPage;

  const verifyEmail(
      {super.key,
      this.name,
      this.email,
      this.password,
      this.phone,
      this.pickedImage,
      required this.fromPage});

  @override
  State<verifyEmail> createState() => _verifyEmailState();
}

class _verifyEmailState extends State<verifyEmail> {
  Timer? timer;
  bool canResendEmail = true;
  bool isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer =
        Timer.periodic(const Duration(seconds: 2), (_) => checkEmailVerified());
    if (!isEmailVerified) {
      sendVerificationEmail();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
     if(widget.fromPage == "register")
       {
         final user = FirebaseAuth.instance.currentUser;
         UploadTask uploadTask = FirebaseStorage.instance
             .ref("UserImages")
             .child(widget.email)
             .putFile(widget.pickedImage!);

         TaskSnapshot taskSnapshot = await uploadTask;
         String imageURL = await taskSnapshot.ref.getDownloadURL();
         FirebaseFirestore.instance.collection("Users").doc(user!.uid).set({
           "name": widget.name,
           "email": widget.email,
           "password": widget.password,
           'uid': user.uid.toString(),
           "birthdate": "",
           "image": imageURL,
           "phone": widget.phone,
           "bio": ""
         });
       }
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const Home()
      : Scaffold(
          appBar: AppBar(
            elevation: 5,
            title: const Text("Verifying  Email.."),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "A Verification Mail  Is Sent to Your Email.",
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: canResendEmail
                      ? ElvB(
                          onTab: () {
                            canResendEmail == true
                                ? FirebaseAuth.instance.currentUser!
                                    .sendEmailVerification()
                                : null;
                            if (!canResendEmail) isLoading = false;
                            if (isEmailVerified) Navigator.pop(context);
                          },
                          text: "Resend Email",
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Verifying Email..",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent),
                            ),
                          ],
                        ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElvB(
                      onTab: () {
                        FirebaseAuth.instance.currentUser!.delete();
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ));
                      },
                      text: "Cancel"),
                )
              ],
            ),
          ),
        );
}
