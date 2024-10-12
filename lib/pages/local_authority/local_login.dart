import 'package:communitycarev4/pages/local_authority/local_dashboard.dart';
import 'package:flutter/material.dart';

class Local_Login extends StatefulWidget {
  const Local_Login({Key? key}) : super(key: key);

  @override
  State<Local_Login> createState() => _LoginState();
}

class _LoginState extends State<Local_Login> {
  final _formKey = GlobalKey<FormState>();

  var email = "";
  var password = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  userLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardScreen(),
      ),
    );
    // Show a snackbar for successful login
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login Successful'),
        backgroundColor: Colors.green, // Change the snackbar color
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Local Official Login"),
        backgroundColor: Colors.blue, // Change the app bar color
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 96, 182, 252),
              Color.fromARGB(255, 255, 235, 58)
            ], // Choose your gradient colors
          ),
        ),
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
                        color: Colors.redAccent,
                        fontSize: 15,
                      ),
                      prefixIcon: Icon(Icons.email), // Email icon
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
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    autofocus: false,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password: ',
                      labelStyle: TextStyle(fontSize: 20.0),
                      border: OutlineInputBorder(),
                      errorStyle: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 15,
                      ),
                      prefixIcon: Icon(Icons.lock), // Password icon
                    ),
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Password';
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
                          // Validate returns true if the form is valid, otherwise false.
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              email = emailController.text;
                              password = passwordController.text;
                            });
                            // Check for specific email and password
                            if (email == "official@gmail.com" &&
                                password == "111222") {
                              userLogin();
                            } else {
                              // Show an error message or handle invalid login
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Invalid email or password'),
                                  backgroundColor:
                                      Colors.red, // Change the snackbar color
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          primary: Colors.blue, // Button color
                          onSurface: Colors.grey,
                          elevation: 5,
                          // Add hover effect
                        ),
                      ),
                      // Remove the Forgot Password button
                    ],
                  ),
                ),
                // Remove the SignUp section
              ],
            ),
          ),
        ),
      ),
    );
  }
}
