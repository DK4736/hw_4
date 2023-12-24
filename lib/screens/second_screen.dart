import 'package:flutter/material.dart';
import 'package:hw_4/models/api.dart';
import 'package:hw_4/database/database_helper.dart';
import 'package:hw_4/models/user.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  late List<User> userList;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      List<User> users = await fetchUserData();
      setState(() {
        userList = users;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> storeDataLocally(User user) async {
    try {
      // Convert User object to Map for SQLite storage
      Map<String, dynamic> userMap = {
        'name': user.name,
        'email': user.email,
        'picture': user.picture,
      };

      // Insert user data into SQLite database
      await DatabaseHelper.insertUser(userMap);

      // Display a success message or update UI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User data stored locally.'),
        ),
      );

      // Navigate to the second screen without replacing it
      Navigator.pushNamed(context, '/second');
    } catch (e) {
      print('Error storing user data locally: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile List'),
      ),
      body: userList == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          User user = userList[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text(user.email),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.picture),
            ),
            onTap: () {
              // Store selected data into SQLite database
              storeDataLocally(user);
            },
          );
        },
      ),
    );
  }
}
