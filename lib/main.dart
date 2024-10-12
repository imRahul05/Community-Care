import 'package:communitycarev4/pages/local_authority/local_homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import "firebase_options.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          // Check for Errors
          if (snapshot.hasError) {
            print("Something Went Wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return MaterialApp(
              title: 'Flutter Firebase EMail Password Auth',
              theme: ThemeData(
                primarySwatch: Colors.orange,
              ),
              debugShowCheckedModeBanner: false,
              home: Local_HomePage());
        });
  }
}
