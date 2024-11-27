import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_firebase/post.dart';

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
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.yellow,
        brightness: Brightness.light,
        // colorScheme: ColorScheme.fromSeed(
        //     seedColor: const Color.fromARGB(255, 93, 15, 230)),
        useMaterial3: true,
      ),
      home: const
          // Splashsrc()
          PostScreen(),
    );
  }
}
