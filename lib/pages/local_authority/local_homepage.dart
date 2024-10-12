import 'package:communitycarev4/pages/local_authority/local_login.dart';
import 'package:communitycarev4/pages/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Local_HomePage(),
    );
  }
}

class Local_HomePage extends StatelessWidget {
  void navigateToUserLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Login(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.fromRGBO(193, 114, 253, 0.973), Color.fromARGB(255, 196, 166, 255)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(70),
                child: Image.asset(
                  'assets/images/logoenvirogif1.gif',
                  height: 300,
                  width: 300,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  navigateToUserLogin(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 93, 206, 99),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: Size(200, 50),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'User',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Local_Login(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 201, 86, 86),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: Size(200, 50),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Official',
                    style: TextStyle(
                      color: Colors.white,
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

