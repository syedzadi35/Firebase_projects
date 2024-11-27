import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? name;
  String? email;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.ref('users');

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    final user = _auth.currentUser; // Get the current logged-in user
    if (user != null) {
      // Fetch user-specific data from Firebase Database
      DatabaseReference userRef = _db.child(user.uid);
      DataSnapshot snapshot = await userRef.get();

      if (snapshot.exists) {
        setState(() {
          name = snapshot.child('name').value.toString(); // Fetch name
          email = user.email; // Fetch email from FirebaseAuth
        });
      } else {
        // Handle case if no user data is available in the database
        setState(() {
          name = "No name provided";
          email = user.email;
        });
      }
    } else {
      setState(() {
        name = "No user logged in";
        email = "No email available";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('User Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Name: ${name ?? "Loading..."}', // Display name or "Loading..." if null
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${email ?? "Loading..."}', // Display email or "Loading..." if null
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
