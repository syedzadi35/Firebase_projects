import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_firebase/forgotscr.dart';
import 'package:login_firebase/my_button.dart';
import 'package:login_firebase/signup_scr.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login screen'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person_2,
                size: 50,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: emailcontroller,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Email',
                    border: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: passwordcontroller,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'password',
                    border: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => forgot()));
                    },
                    child: Text(
                      'forgot password',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
            SizedBox(
              height: 30,
            ),
            MyButton(
                title: 'Log in',
                onButtonpress: () {
                  auth
                      .signInWithEmailAndPassword(
                          email: emailcontroller.text.toString(),
                          password: passwordcontroller.text.toString())
                      .then((onValue) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('login successful')));
                    // print(onValue.toString());
                  }).catchError((onError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(onError.toString())));

                    // print(onError.toString());
                  });
                  ;
                }),
            SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => sighnup()));
              },
              child: Text('Dont have an account!sign up'),
            )
          ],
        ),
      ),
    );
  }
}
