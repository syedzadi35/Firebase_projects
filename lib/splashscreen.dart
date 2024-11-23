import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_firebase/Loginscr.dart';

import 'package:login_firebase/signup_scr.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.yellow,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      home: const Splashsrc(),
    );
  }
}

class Splashsrc extends StatefulWidget {
  const Splashsrc({super.key});

  @override
  State<Splashsrc> createState() => _SplashsrcState();
}

class _SplashsrcState extends State<Splashsrc> {
  @override
  void initState() {
    super.initState();
    moveNextScreen();
  }

  void moveNextScreen() {
    final user = FirebaseAuth.instance.currentUser;
    Future.delayed(const Duration(seconds: 5), () {
      print('user: $user');
      if (user == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => sighnup()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const login()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Welcome to My App',
                style: TextStyle(color: Colors.black, fontSize: 24)),
          ],
        ),
      ),
    );
  }
}