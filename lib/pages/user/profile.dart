import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final email = FirebaseAuth.instance.currentUser!.email;
  final creationTime = FirebaseAuth.instance.currentUser!.metadata.creationTime;

  User? user = FirebaseAuth.instance.currentUser;

  verifyEmail() async {
    if (user != null && !user!.emailVerified) {
      await user!.sendEmailVerification();
      print('Verification Email has been sent');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Verification Email has been sent',
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Add a light background color
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User ID: $uid',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              Text(
                'Email: $email',
                style: TextStyle(fontSize: 18.0),
              ),
              user!.emailVerified
                  ? Text(
                      ' verified',
                      style: TextStyle(fontSize: 18.0, color: Colors.green),
                    )
                  : TextButton(
                      onPressed: () => {verifyEmail()},
                      child: Text(
                        'Verify Email',
                        style: TextStyle(fontSize: 12.0, color: Colors.blue),
                      ),
                    ),
            ],
          ),
          SizedBox(height: 10.0),
          Text(
            'Created: $creationTime',
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}
