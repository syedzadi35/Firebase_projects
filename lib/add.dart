import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import flutter toast package

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref('posts');
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isLoading = false; // State for showing loading spinner

  void addPost() {
    setState(() {
      isLoading = true; // Start loading
    });

    // Generate a unique numeric ID using the current timestamp
    String customId = DateTime.now().millisecondsSinceEpoch.toString();

    // Add data to the database using the custom ID
    databaseRef.child(customId).set({
      'id': customId,
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
    }).then((_) {
      setState(() {
        isLoading = false; // Stop loading
      });

      // Show success toast
      Fluttertoast.showToast(
        msg: "Post added successfully!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.pop(context); // Navigate back to the previous screen
    }).catchError((error) {
      setState(() {
        isLoading = false; // Stop loading
      });

      // Show error toast
      Fluttertoast.showToast(
        msg: "Failed to add post: $error",
        toastLength: Toast.LENGTH_LONG,
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
        title: const Text('Add Post'),
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
              onPressed:
                  isLoading ? null : addPost, // Disable button if loading
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Add Post'),
            ),
          ],
        ),
      ),
    );
  }
}
