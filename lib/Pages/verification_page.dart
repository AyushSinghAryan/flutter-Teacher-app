import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_teacher_app/Pages/student_details.dart';
import 'home_page.dart';

class VerificationPage extends StatefulWidget {
  final User user;
  const VerificationPage({required this.user});

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool isVerified = false;

  @override
  void initState() {
    super.initState();
    checkEmailVerified();
  }

  Future<void> checkEmailVerified() async {
    await widget.user.reload();
    var user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      setState(() {
        isVerified = true;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StudentDetails(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  'A verification email has been sent to ${widget.user.email}. Please verify your email.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange, // Text color
                minimumSize: Size(350, 50), // Width and height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rectangle shape
                ),
                elevation: 10, // Shadow elevation
              ),
              onPressed: () {
                checkEmailVerified();
              },
              child: Text("I've Verified My Email"),
            ),
          ],
        ),
      ),
    );
  }
}
