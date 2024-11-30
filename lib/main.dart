import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_firebase/splashscreen.dart';

void main() async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA9of59kzIFTTH3H6xXgn8zNRGPhC_su50",
      authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
      databaseURL: "https://login-firebase-d53a8-default-rtdb.firebaseio.com",
      projectId: "YOUR_PROJECT_ID",
      storageBucket: "YOUR_PROJECT_ID.appspot.com",
      messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
      appId: "YOUR_APP_ID",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter login page',
      theme: ThemeData(
        primaryColor: Colors.yellow,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      home: const Splashsrc(),
    );
  }
}
