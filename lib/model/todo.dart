import 'package:todo_list/model/user.dart';

class Todo {
  final int userId;
  final int id;
  final String title;
  bool completed;
  User? user;

  Todo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
    this.user,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        completed: json["completed"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "completed": completed,
      };
}
