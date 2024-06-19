import 'package:flutter/material.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/provider/todo_provider.dart';
import 'package:todo_list/screen/detail_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TodoItem extends StatefulWidget {
  final Todo todo;
  final VoidCallback onRemove;

  const TodoItem({super.key, required this.todo, required this.onRemove});

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool isChecked = false;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.5, -0.5),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
  }

  void _handleVisibilityChange(double visibleFraction) {
    setState(() {
      isVisible = visibleFraction > 0.5;
      if (isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.read<TodoProvider>();
    return VisibilityDetector(
      key: Key(widget.todo.title),
      onVisibilityChanged: (visibilityInfo) {
        if (mounted) {
          _handleVisibilityChange(visibilityInfo.visibleFraction);
        }
      },
      child: AnimatedBuilder(
        animation: _offsetAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: _offsetAnimation.value,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: widget.todo.completed
                        ? const Color.fromRGBO(218, 245, 240, 1)
                        : Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    boxShadow: isVisible
                        ? const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(4, 6),
                              spreadRadius: 1,
                            ),
                          ]
                        : const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(0, 0),
                              spreadRadius: 1,
                            ),
                          ]),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailScreen(id: widget.todo.id),
                    ));
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    widget.todo.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  dense: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MSHCheckbox(
                        size: 25,
                        value: widget.todo.completed,
                        colorConfig:
                            MSHColorConfig.fromCheckedUncheckedDisabled(
                          uncheckedColor: Colors.black,
                        ),
                        style: MSHCheckboxStyle.stroke,
                        onChanged: (selected) {
                          print("clicked");
                          todoProvider.updateStatus(widget.todo.id, selected);
                        },
                      ),
                      IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            toastification.show(
                              direction: TextDirection.ltr,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              animationBuilder:
                                  (context, animation, alignment, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              showProgressBar: false,
                              icon: const Icon(Icons.check),
                              context: context,
                              type: ToastificationType.success,
                              title: const Text("todo removed"),
                              style: ToastificationStyle.flatColored,
                              autoCloseDuration: const Duration(seconds: 2),
                            );
                            widget.onRemove();
                          }),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
