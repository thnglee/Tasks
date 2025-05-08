import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../todo_model.dart';

class TodoNotifier extends Notifier<Map<String, Todo>> {
  @override
  Map<String, Todo> build() => {};

  void addTodo(String title) {
    final id = DateTime.now().toString();
    final newTodo = Todo(
      id: id,
      title: title,
    );
    state = Map.from(state)..[id] = newTodo;
  }

  void toggleTodo(String id) {
    if (!state.containsKey(id)) return;
    final updatedTodo = state[id]!.copyWith(isDone: !state[id]!.isDone);
    state = Map.from(state)..[id] = updatedTodo;
  }

  void removeTodo(String id) {
    final newState = Map<String, Todo>.from(state);
    newState.remove(id);
    state = newState;
  }

  List<Todo> get todosList => state.values.toList();
}

final todoProvider = NotifierProvider<TodoNotifier, Map<String, Todo>>(TodoNotifier.new);

// Individual todo item provider for more granular updates
final todoItemProvider = Provider.family<Todo?, String>((ref, id) {
  return ref.watch(todoProvider)[id];
});

// Provider for the todos list
final todosListProvider = Provider<List<Todo>>((ref) {
  return ref.watch(todoProvider).values.toList();
}); 