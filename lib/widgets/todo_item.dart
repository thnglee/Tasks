import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/todo_provider.dart';

class TodoItem extends ConsumerWidget {
  final String todoId;

  const TodoItem({
    super.key,
    required this.todoId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(todoItemProvider(todoId));
    
    if (todo == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        child: ListTile(
          leading: CheckboxTheme(
            data: CheckboxThemeData(
              shape: const CircleBorder(),
              side: AppTheme.checkboxBorderSide,
              fillColor: AppTheme.checkboxFillColor,
            ),
            child: Checkbox(
              value: todo.isDone,
              onChanged: (bool? _) {
                ref.read(todoProvider.notifier).toggleTodo(todoId);
              },
            ),
          ),
          title: Text(
            todo.title,
            style: AppTheme.bodyStyle.copyWith(
              decoration: todo.isDone ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: AppTheme.white),
            onPressed: () {
              ref.read(todoProvider.notifier).removeTodo(todoId);
            },
          ),
        ),
      ),
    );
  }
} 