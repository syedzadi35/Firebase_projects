import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'Loginscr.dart';
import 'add.dart';
import 'updatedscr.dart'; // Update Task Screen

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref('posts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Post Screen'),
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const login()),
              );
            },
            child: const Icon(Icons.logout),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FirebaseAnimatedList(
          query: databaseRef,
          itemBuilder: (context, snapshot, animation, index) {
            Map<dynamic, dynamic> post =
                snapshot.value as Map<dynamic, dynamic>? ?? {};

            String id = snapshot.key ?? '';
            String title = post['title'] ?? 'No Title';
            String description = post['description'] ?? 'No Description';

            return Card(
              child: ListTile(
                title: Text(title),
                subtitle: Text(description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Edit Icon
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        // Navigate to UpdateTaskScreen with current data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateTaskScreen(
                              title: title,
                              description: description,
                              id: id,
                            ),
                          ),
                        );
                      },
                    ),
                    // Delete Icon
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Delete post directly
                        databaseRef.child(id).remove().then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Task deleted successfully'),
                            ),
                          );
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to delete task: $error'),
                            ),
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPostScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
