import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'add.dart'; // Add post screen
import 'updatedscr.dart'; // Update Task Screen
import 'profile.dart'; // Profile screen
import 'Loginscr.dart'; // Login screen

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref('posts');
  String _searchQuery = ""; // For search filtering
  User? currentUser;
  DatabaseReference? userPostsRef; // User-specific data reference

  @override
  void initState() {
    super.initState();
    currentUser = auth.currentUser;

    if (currentUser != null) {
      String userEmail = currentUser!.email!.replaceAll('.', '_');
      userPostsRef = databaseRef.child(userEmail); // User-specific path
    }
  }

  // Function to log out the user
  void _logout() async {
    try {
      await auth.signOut();
      setState(() {
        userPostsRef = null;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const login()),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error logging out: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // Navigate to the profile screen
  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Profile()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Post Screen'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: _goToProfile,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search posts...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase(); // Update search query
                });
              },
            ),
          ),
          // Firebase Stream for real-time updates
          Expanded(
            child: userPostsRef == null
                ? const Center(
                    child: Text(
                      'No data available. Please log in.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : FirebaseAnimatedList(
                    query: userPostsRef!,
                    itemBuilder: (context, snapshot, animation, index) {
                      Map<dynamic, dynamic>? post =
                          snapshot.value as Map<dynamic, dynamic>?;
                      if (post == null) return const SizedBox();

                      String id = snapshot.key ?? '';
                      String title = post['title'] ?? 'No Title';
                      String description =
                          post['description'] ?? 'No Description';

                      // Filter posts using search query
                      if (!_searchQuery.isEmpty &&
                          !title.toLowerCase().contains(_searchQuery)) {
                        return const SizedBox(); // Skip items not matching search
                      }

                      return FadeTransition(
                        opacity: animation,
                        child: Card(
                          child: ListTile(
                            title: Text(title),
                            subtitle: Text(description),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Edit Button
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateTaskScreen(
                                          title: title,
                                          description: description,
                                          id: id,
                                        ),
                                      ),
                                    );
                                    if (result == true) {
                                      setState(() {}); // Trigger UI refresh
                                    }
                                  },
                                ),
                                // Delete Button
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    userPostsRef!.child(id).remove().then((_) {
                                      Fluttertoast.showToast(
                                        msg: "Task deleted successfully",
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                      );
                                    }).catchError((error) {
                                      Fluttertoast.showToast(
                                        msg: "Failed to delete task: $error",
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
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
