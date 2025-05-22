import 'package:flutter/material.dart';
import '../todo_model.dart';
import '../theme/app_theme.dart';
import 'todo_item.dart';

class AnimatedTodoList extends StatefulWidget {
  final List<Todo> todos;
  final ScrollController scrollController;

  const AnimatedTodoList({
    super.key,
    required this.todos,
    required this.scrollController,
  });

  @override
  State<AnimatedTodoList> createState() => _AnimatedTodoListState();
}

class _AnimatedTodoListState extends State<AnimatedTodoList> {
  final Map<String, bool> _newItems = {};

  @override
  void didUpdateWidget(AnimatedTodoList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check for new items
    if (widget.todos.isNotEmpty &&
        (oldWidget.todos.isEmpty ||
            widget.todos.first.id != oldWidget.todos.first.id)) {
      _newItems[widget.todos.first.id] = true;
      // Remove the new item flag after animation
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _newItems.remove(widget.todos.first.id);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ListView.builder(
        controller: widget.scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        itemCount: widget.todos.length,
        itemBuilder: (context, index) {
          final todo = widget.todos[index];
          final isNewItem = _newItems[todo.id] == true;

          return AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: TweenAnimationBuilder<double>(
              key: ValueKey(todo.id),
              tween: Tween<double>(begin: isNewItem ? 0.0 : 1.0, end: 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              builder: (context, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: TodoItem(
                key: ValueKey('item_${todo.id}'),
                todoId: todo.id,
              ),
            ),
          );
        },
      ),
    );
  }
}
