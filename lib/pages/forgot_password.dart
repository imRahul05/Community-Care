import 'package:communitycarev4/pages/login.dart';
import 'package:communitycarev4/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  var email = "";

  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Password Reset Email has been sent!',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              'No user found for that email.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reset Password",
          style: TextStyle(fontSize: 24.0),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlue, Colors.lightGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.lightBlue, Colors.lightGreen],
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Text(
                'Reset Link will be sent to your email id!',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          autofocus: false,
                          decoration: InputDecoration(
                            labelText: 'Email: ',
                            labelStyle: TextStyle(fontSize: 20.0),
                            border: OutlineInputBorder(),
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 15),
                          ),
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Email';
                            } else if (!value.contains('@')) {
                              return 'Please Enter Valid Email';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 60.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    email = emailController.text;
                                  });
                                  resetPassword();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Color.fromARGB(255, 12, 12, 12),
                                elevation: 5,
                              ),
                              child: Text(
                                'Send Email',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                            TextButton(
                              onPressed: () => {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, a, b) => Login(),
                                      transitionDuration: Duration(seconds: 0),
                                    ),
                                    (route) => false)
                              },
                              style: TextButton.styleFrom(
                                primary: Colors.black,
                              ),
                              child: Text(
                                'Login',
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an Account? "),
                            TextButton(
                              onPressed: () => {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, a, b) => Signup(),
                                      transitionDuration: Duration(seconds: 0),
                                    ),
                                    (route) => false)
                              },
                              style: TextButton.styleFrom(
                                primary: Colors.black,
                              ),
                              child: Text('Signup'),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
