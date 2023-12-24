import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hw_4/models/user.dart';

Future<List<User>> fetchUserData() async {
  final response = await http.get(Uri.parse('https://randomuser.me/api/?results=5'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body)['results'] as List<dynamic>;
    return data.map((user) => User(
      name: '${user['name']['first']} ${user['name']['last']}',
      email: user['email'],
      picture: user['picture']['thumbnail'],
    )).toList();
  } else {
    throw Exception('Failed to load user data');
  }
}
