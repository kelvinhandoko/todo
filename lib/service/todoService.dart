import 'dart:convert';

import 'package:todo_list/model/todo.dart';
import 'package:http/http.dart' as http;
import 'package:todo_list/service/userService.dart';

const baseUrl = 'https://jsonplaceholder.typicode.com/todos';

class TodoService {
  static Future<List<Todo>> getTodos() async {
    await Future.delayed(const Duration(seconds: 2));
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Todo> todos =
          body.map((dynamic item) => Todo.fromJson(item)).toList();
      return todos;
    } else {
      throw Exception('Failed to load todos');
    }
  }
}
