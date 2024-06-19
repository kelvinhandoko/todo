import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/provider/todo_provider.dart';

class DetailScreen extends StatefulWidget {
  final int id;

  const DetailScreen({super.key, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isClicked = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TodoProvider>().setCurrentTodo(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        if (todoProvider.isLoading) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Detail Screen'),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (todoProvider.errorMessage.isNotEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Detail Screen'),
            ),
            body: Center(child: Text(todoProvider.errorMessage)),
          );
        }

        final todo = todoProvider.currentTodo;
        if (todo == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Detail Screen'),
            ),
            body: const Center(child: Text('Todo not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detail Screen'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: todo.completed ? Colors.green[300] : Colors.red[300],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    todo.completed ? 'Completed' : 'In Progress',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title: ${todo.title}',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Assigned to: ${todo.user?.name ?? 'Unknown'}',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Company: ${todo.user?.company.name ?? 'Unknown'}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    todoProvider.updateStatus(todo.id, !todo.completed);
                  },
                  onTapUp: (_) {
                    setState(() {
                      isClicked = false;
                    });
                  },
                  onTapDown: (_) {
                    setState(() {
                      isClicked = true;
                    });
                  },
                  child: Transform.translate(
                    offset:
                        isClicked ? const Offset(0, 0) : const Offset(-1, -1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: todo.completed
                            ? const Color.fromRGBO(218, 245, 240, 1)
                            : Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            offset: isClicked
                                ? const Offset(0, 0)
                                : const Offset(4, 6),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Text(
                        "Mark as ${!todo.completed ? 'Completed' : 'In Progress'}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
