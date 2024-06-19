import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/provider/todo_provider.dart';
import 'package:todo_list/widget/todoItem.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        if (todoProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return AnimatedList(
          key: _listKey,
          initialItemCount: todoProvider.todos.length,
          itemBuilder: (context, index, animation) {
            final todo = todoProvider.todos[index];
            return _buildTodoItem(todo, index, animation);
          },
        );
      },
    );
  }

  Widget _buildTodoItem(Todo todo, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: TodoItem(
        key: ValueKey(todo.id),
        todo: todo,
        onRemove: () {
          final todoProvider = context.read<TodoProvider>();
          final removedTodo = todoProvider.todos[index];
          todoProvider.removeTodo(index);
          _listKey.currentState!.removeItem(
            index,
            (context, animation) => _buildRemovedItem(removedTodo, animation),
          );
        },
      ),
    );
  }

  Widget _buildRemovedItem(Todo todo, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: const SizedBox(
        width: double.infinity,
        height: 24,
      ),
    );
  }
}
