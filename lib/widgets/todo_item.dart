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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (todo == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        color: (isDark ? Colors.white : Colors.black).withOpacity(isDark ? 0.15 : 0.05),
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        child: ListTile(
          leading: CheckboxTheme(
            data: CheckboxThemeData(
              shape: const CircleBorder(),
              side: isDark ? AppTheme.checkboxBorderSide : BorderSide(color: AppTheme.borderColorLight),
              fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return isDark ? AppTheme.primaryGrey : AppTheme.primaryBlue;
                }
                return Colors.transparent;
              }),
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
            style: (isDark ? AppTheme.bodyStyle : AppTheme.bodyStyleLight).copyWith(
              decoration: todo.isDone ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.delete,
              color: isDark ? AppTheme.white : AppTheme.textDark,
            ),
            onPressed: () {
              ref.read(todoProvider.notifier).removeTodo(todoId);
            },
          ),
        ),
      ),
    );
  }
} 