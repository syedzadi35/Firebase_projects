import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

      Navigator.pop(context);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Update Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.yellow),
              ),
              onPressed: isUpdating ? null : updateTask,
              child: isUpdating
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}
