import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_firebase/Loginscr.dart';
import 'package:login_firebase/my_button.dart';
import 'package:login_firebase/widgets/bg%20color.dart';

class forgot extends StatefulWidget {
  const forgot({super.key});

  @override
  State<forgot> createState() => _forgotState();
}

class _forgotState extends State<forgot> {
  TextEditingController emailcontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const background(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()));
                        },
                        child: const Icon(Icons.arrow_back)),
                    const SizedBox(
                      width: 30,
                    ),
                    const Text(
                      'Enter your Email',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  controller: emailcontroller,
                  decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(color: Colors.yellow)),
                      prefixIcon: const Icon(Icons.email),
                      hintText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                ),
                const SizedBox(
                  height: 10,
                ),
                MyButton(
                    title: 'send email',
                    onButtonpress: () {
                      auth
                          .sendPasswordResetEmail(
                              email: emailcontroller.text.toString())
                          .then((onValue) {
                        Fluttertoast.showToast(
                          msg: 'email send successfully',
                        );
                      }).catchError((onError) {
                        Fluttertoast.showToast(msg: onError.toString());
                        print(onError.toString());
                      });
                    }),
              ],
            ),
          ),
        )
      ],
    );
  }
}
