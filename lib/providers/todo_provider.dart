import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../todo_model.dart';
import '../services/hive_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/supabase_service.dart';
import 'package:uuid/uuid.dart';

class TodoNotifier extends Notifier<Map<String, Todo>> {
  @override
  Map<String, Todo> build() {
    // Load initial todos from Hive
    final todos = HiveService.getAllTodos();
    return {for (var todo in todos) todo.id: todo};
  }

  Future<void> addTodo(String title) async {
    final now = DateTime.now();
    final id = const Uuid().v4();
    final newTodo = Todo(
      id: id,
      title: title,
      isDone: false,
      createdAt: now,
      updatedAt: now,
      deleted: false,
    );
    await HiveService.addTodo(newTodo);
    state = Map.from(state)..[id] = newTodo;

    final connectivity = await Connectivity().checkConnectivity();
    final isOnline = connectivity != ConnectivityResult.none;
    final taskMap = newTodo.toMap();
    if (isOnline) {
      await SupabaseService.addTaskToSupabase(taskMap);
    } else {
      await HiveService.addToSyncQueue({'action': 'add', 'task': taskMap});
    }
  }

  Future<void> toggleTodo(String id) async {
    if (!state.containsKey(id)) return;
    final updatedTodo = state[id]!.copyWith(
      isDone: !state[id]!.isDone,
      updatedAt: DateTime.now(),
    );
    await HiveService.updateTodo(updatedTodo);
    state = Map.from(state)..[id] = updatedTodo;

    final connectivity = await Connectivity().checkConnectivity();
    final isOnline = connectivity != ConnectivityResult.none;
    final taskMap = updatedTodo.toMap();
    if (isOnline) {
      await SupabaseService.updateTaskInSupabase(taskMap);
    } else {
      await HiveService.addToSyncQueue({'action': 'update', 'task': taskMap});
    }
  }

  Future<void> removeTodo(String id) async {
    if (!state.containsKey(id)) return;
    // Soft delete: set deleted = true and update updatedAt
    final deletedTodo = state[id]!.copyWith(
      deleted: true,
      updatedAt: DateTime.now(),
    );
    await HiveService.updateTodo(deletedTodo);
    final newState = Map<String, Todo>.from(state);
    newState[id] = deletedTodo;
    state = newState;

    final connectivity = await Connectivity().checkConnectivity();
    final isOnline = connectivity != ConnectivityResult.none;
    final taskMap = deletedTodo.toMap();
    if (isOnline) {
      await SupabaseService.updateTaskInSupabase(taskMap);
    } else {
      await HiveService.addToSyncQueue({'action': 'delete', 'task': taskMap});
    }
  }

  List<Todo> get todosList =>
      state.values.where((todo) => !todo.deleted).toList();
}

final todoProvider = NotifierProvider<TodoNotifier, Map<String, Todo>>(TodoNotifier.new);

// Individual todo item provider for more granular updates
final todoItemProvider = Provider.family<Todo?, String>((ref, id) {
  return ref.watch(todoProvider)[id];
});

// Provider for the todos list
final todosListProvider = Provider<List<Todo>>((ref) {
  return ref.watch(todoProvider).values.where((todo) => !todo.deleted).toList();
}); 