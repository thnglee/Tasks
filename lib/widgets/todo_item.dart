import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/todo_provider.dart';

class TodoItem extends ConsumerWidget {
  final String todoId;

  const TodoItem({super.key, required this.todoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(todoItemProvider(todoId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (todo == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        decoration:
            isDark
                ? AppTheme.taskItemDecoration
                : AppTheme.taskItemDecorationLight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => ref.read(todoProvider.notifier).toggleTodo(todoId),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primaryPurple.withOpacity(0.5),
                          width: 2,
                        ),
                        color:
                            todo.isDone
                                ? AppTheme.primaryPurple
                                : Colors.transparent,
                      ),
                      child:
                          todo.isDone
                              ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                              : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        todo.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          decoration:
                              todo.isDone ? TextDecoration.lineThrough : null,
                          color:
                              todo.isDone
                                  ? (isDark
                                          ? AppTheme.textLight
                                          : AppTheme.textDark)
                                      .withOpacity(0.5)
                                  : (isDark
                                      ? AppTheme.textLight
                                      : AppTheme.textDark),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: (isDark ? AppTheme.textLight : AppTheme.textDark)
                            .withOpacity(0.5),
                        size: 20,
                      ),
                      onPressed: () {
                        ref.read(todoProvider.notifier).removeTodo(todoId);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
