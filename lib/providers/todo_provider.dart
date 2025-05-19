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
    // Start listening to Supabase realtime
    SupabaseService.listenToTasksTable(
      onInsert: (data) {
        print('[Realtime] Insert event received: $data');
        final todo = Todo.fromMap(data);
        HiveService.addTodo(todo).then((_) {
          final updated = Map<String, Todo>.from(state)..[todo.id] = todo;
          final sorted =
              updated.values.toList()
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          state = {for (var t in sorted) t.id: t};
        });
      },
      onUpdate: (data) {
        print('[Realtime] Update event received: $data');
        final todo = Todo.fromMap(data);
        HiveService.updateTodo(todo).then((_) {
          final updated = Map<String, Todo>.from(state)..[todo.id] = todo;
          final sorted =
              updated.values.toList()
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          state = {for (var t in sorted) t.id: t};
        });
      },
      onDelete: (data) {
        print('[Realtime] Delete event received: $data');
        final id = data['id']?.toString();
        if (id != null) {
          HiveService.deleteTodo(id).then((_) {
            final newState = Map<String, Todo>.from(state);
            newState.remove(id);
            state = newState;
          });
        }
      },
    );
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
    // Insert new todo and re-sort by createdAt descending
    final todos = [newTodo, ...state.values];
    todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = {for (var todo in todos) todo.id: todo};

    // Debug log: print all createdAt values
    final createdAts = todos
        .map((t) => '[${t.title}] ${t.createdAt.toIso8601String()}')
        .join(', ');
    // ignore: avoid_print
    print('DEBUG: Todos order after add: $createdAts');

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

final todoProvider = NotifierProvider<TodoNotifier, Map<String, Todo>>(
  TodoNotifier.new,
);

// Individual todo item provider for more granular updates
final todoItemProvider = Provider.family<Todo?, String>((ref, id) {
  return ref.watch(todoProvider)[id];
});

// Provider for the todos list
final todosListProvider = Provider<List<Todo>>((ref) {
  final todos =
      ref.watch(todoProvider).values.where((todo) => !todo.deleted).toList();
  todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return todos;
});
