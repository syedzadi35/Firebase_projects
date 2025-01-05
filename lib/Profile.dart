import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:login_firebase/post.dart';
import 'package:login_firebase/widgets/bg%20color.dart';

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
    return Stack(
      children: [
        const background(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context,
                                (builder: (context) => const PostScreen()));
                          },
                          child: const Icon(Icons.arrow_back)),
                      const SizedBox(
                        width: 30,
                      ),
                      const Text(
                        'User Profile',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
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
          ),
        ),
      ],
    );

    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [

    //       ],
    //     ),
    //   ),
    // );
  }
}
