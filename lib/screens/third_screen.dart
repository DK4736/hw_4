import 'package:flutter/material.dart';
import 'package:hw_4/database/database_helper.dart';

class ThirdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Local Profile List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Map<String, dynamic>> userList = snapshot.data ?? [];

            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> user = userList[index];
                return ListTile(
                  title: Text(user['name']),
                  subtitle: Text(user['email']),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['picture']),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
