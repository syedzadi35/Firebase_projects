import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_firebase/Loginscr.dart';
import 'package:login_firebase/widgets/bg%20color.dart';

class UpdateTaskScreen extends StatefulWidget {
  const UpdateTaskScreen({
    super.key,
    required this.title,
    required this.description,
    required this.id,
  });

  final String title;
  final String description;
  final String id;

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  final database = FirebaseDatabase.instance.ref('posts');
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    descriptionController.text = widget.description;
  }

  void updateTask() {
    setState(() {
      isUpdating = true;
    });

    database.child(widget.id).update({
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
    }).then((_) {
      setState(() {
        isUpdating = false;
      });

      // Show success toast
      Fluttertoast.showToast(
        msg: "Task updated successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Return true to PostScreen indicating update success
      Navigator.pop(context, true);
    }).catchError((error) {
      setState(() {
        isUpdating = false;
      });

      // Show error toast
      Fluttertoast.showToast(
        msg: "Failed to update task: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        background(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
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
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.yellow),
                    ),
                    onPressed: isUpdating ? null : updateTask,
                    child: isUpdating
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Update Task',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
