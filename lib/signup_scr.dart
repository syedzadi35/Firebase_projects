import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_firebase/post.dart';
import 'package:login_firebase/widgets/bg%20color.dart';
import 'Loginscr.dart';

class Signup extends StatefulWidget {
  Signup({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final databaseRef =
      FirebaseDatabase.instance.ref(); // Firebase database reference
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const background(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(
                                context, (builder: (context) => const Login()));
                          },
                          child: const Icon(Icons.arrow_back),
                        ),
                        const SizedBox(width: 30),
                        const Text(
                          'Welcome \nCreate New Account',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Form(
                        key: widget._formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  AssetImage('assets/profile.jpeg'),
                            ),
                            const SizedBox(height: 30),
                            // Name Field
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.yellow),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  prefixIcon: const Icon(Icons.person),
                                  hintText: 'Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 10),

                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.yellow),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  prefixIcon: const Icon(Icons.email),
                                  hintText: 'Email',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter an email';
                                  }
                                  if (!RegExp(r'\S+@\S+\.\S+')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 10),

                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.yellow),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  prefixIcon: const Icon(Icons.lock),
                                  hintText: 'Password',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Sign Up Button
                            ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      if (widget._formKey.currentState!
                                          .validate()) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        try {
                                          UserCredential userCredential =
                                              await auth
                                                  .createUserWithEmailAndPassword(
                                            email: emailController.text.trim(),
                                            password:
                                                passwordController.text.trim(),
                                          );

                                          // Save user data to Firebase Database
                                          String userId =
                                              userCredential.user!.uid;
                                          await databaseRef
                                              .child('users')
                                              .child(userId)
                                              .set({
                                            'name': nameController.text.trim(),
                                            'email':
                                                emailController.text.trim(),
                                            'createdAt':
                                                DateTime.now().toString(),
                                          });

                                          Fluttertoast.showToast(
                                            msg: 'Sign up successful!',
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                          );
                                          Navigator.pushReplacement(
                                            // ignore: use_build_context_synchronously
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const PostScreen()),
                                          );
                                        } catch (error) {
                                          Fluttertoast.showToast(
                                            msg: 'Error: $error',
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                          );
                                        } finally {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                          msg:
                                              'Please fill in all fields correctly',
                                          backgroundColor: Colors.orange,
                                          textColor: Colors.white,
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 40.0),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()),
                                );
                              },
                              child: const Text(
                                'Already have an account? Log in',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 247, 238, 170)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
