import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For user authentication
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart'; // For toast notifications

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref('posts');
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance; // Firebase Authentication
  User? currentUser;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    currentUser = auth.currentUser; // Get the currently logged-in user
  }

  void addPost() {
    if (currentUser == null) {
      Fluttertoast.showToast(
        msg: "No user is logged in.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return; // If no user is logged in, stop the function.
    }

    setState(() {
      isLoading = true;
    });

    String customId = DateTime.now().millisecondsSinceEpoch.toString();

    // Replace '.' in email with '_', this ensures valid Firebase paths
    String userEmail = currentUser!.email!.replaceAll('.', '_');

    // Save task under the current user's email
    databaseRef
        .child(userEmail) // Use the modified email as the path
        .child(customId)
        .set({
      'id': customId,
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
    }).then((_) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(
        msg: "Post added successfully!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.pop(context);
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });

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
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              onPressed: isLoading ? null : addPost,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Add Post',
                      style: TextStyle(color: Colors.black),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
