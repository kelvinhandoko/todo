import 'dart:convert';

import 'package:todo_list/model/user.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'https://jsonplaceholder.typicode.com/users';

class UserService {
  static Future<User> getUserDetail(int id) async {
    await Future.delayed(const Duration(seconds: 2));
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user detail');
    }
  }
}
