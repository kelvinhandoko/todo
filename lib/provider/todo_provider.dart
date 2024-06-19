import 'package:flutter/cupertino.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/service/todoService.dart';
import 'package:todo_list/service/userService.dart';

class TodoProvider extends ChangeNotifier {
  TodoProvider() {
    _fetchInitial();
  }

  final List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String _errorMessage = "";

  String get errorMessage => _errorMessage;

  Todo? _currentTodo;

  Todo? get currentTodo => _currentTodo;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  _fetchInitial() async {
    try {
      _setLoading(true);
      final res = await TodoService.getTodos();
      _todos.addAll(res);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void setCurrentTodo(int id) async {
    try {
      _setLoading(true);
      Todo todo = _todos.firstWhere((todo) => todo.id == id);
      final currentUser = await UserService.getUserDetail(todo.userId);
      todo.user = currentUser;
      _currentTodo = todo;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void updateStatus(int id, bool isCompleted) {
    final index = _todos.indexWhere((element) => element.id == id);
    _todos[index].completed = isCompleted;
    notifyListeners();
  }

  void removeTodo(int index) {
    _todos.removeAt(index);
    notifyListeners();
  }
}
