import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../todo_model.dart';
import 'log_service.dart';

class HiveService {
  static const String _todoBoxName = 'todos';
  static const String _settingsBoxName = 'settings';
  static const String _themeModeKey = 'themeMode';
  static const String _lastSyncTimeKey = 'lastSyncTime';
  static const String _isFirstLaunchKey = 'isFirstLaunch';
  static const String _syncQueueKey = 'syncQueue';

  static Future<void> init() async {
    LogService.database('Initializing Hive...');
    if (kIsWeb) {
      await Hive.initFlutter();
    } else {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocumentDir.path);
    }
    Hive.registerAdapter(TodoAdapter());
    await Hive.openBox<Todo>(_todoBoxName);
    await Hive.openBox(_settingsBoxName);
    LogService.database('Hive initialized successfully');
  }

  static Box<Todo> get todoBox => Hive.box<Todo>(_todoBoxName);

  static Box get settingsBox => Hive.box(_settingsBoxName);

  static Future<void> addTodo(Todo todo) async {
    LogService.database('Adding todo: ${todo.id}');
    await todoBox.put(todo.id, todo);
  }

  static Future<void> updateTodo(Todo todo) async {
    LogService.database('Updating todo: ${todo.id}');
    await todoBox.put(todo.id, todo);
  }

  static Future<void> deleteTodo(String id) async {
    LogService.database('Deleting todo: $id');
    await todoBox.delete(id);
  }

  static List<Todo> getAllTodos() {
    final todos = todoBox.values.toList();
    todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    LogService.database('Retrieved ${todos.length} todos');
    return todos;
  }

  static Future<void> clearAllTodos() async {
    LogService.database('Clearing all todos');
    await todoBox.clear();
  }

  static Future<void> setThemeMode(String mode) async {
    await settingsBox.put(_themeModeKey, mode);
  }

  static String? getThemeMode() {
    return settingsBox.get(_themeModeKey) as String?;
  }

  static Future<void> setLastSyncTime(DateTime time) async {
    LogService.database('Setting last sync time: ${time.toIso8601String()}');
    await settingsBox.put(_lastSyncTimeKey, time.toIso8601String());
  }

  static DateTime? getLastSyncTime() {
    final value = settingsBox.get(_lastSyncTimeKey) as String?;
    if (value == null) {
      LogService.database('No previous sync time found');
      return null;
    }
    final time = DateTime.tryParse(value);
    LogService.database('Last sync time: ${time?.toIso8601String()}');
    return time;
  }

  static Future<void> setIsFirstLaunch(bool value) async {
    LogService.database('Setting first launch state to: $value');
    await settingsBox.put(_isFirstLaunchKey, value);
  }

  static bool getIsFirstLaunch() {
    final value = settingsBox.get(_isFirstLaunchKey);
    final isFirstLaunch = value == null ? true : value as bool;
    LogService.database('Checking first launch: $isFirstLaunch');
    if (isFirstLaunch) {
      LogService.info('This is the first time the app is launched');
    } else {
      LogService.debug('App has been launched before');
    }
    return isFirstLaunch;
  }

  // Sync Queue Methods
  static Future<void> addToSyncQueue(Map<String, dynamic> change) async {
    LogService.database('Adding item to sync queue');
    final List<dynamic> queue =
        settingsBox.get(_syncQueueKey, defaultValue: []) as List<dynamic>;
    queue.add(change);
    await settingsBox.put(_syncQueueKey, queue);
  }

  static List<Map<String, dynamic>> getSyncQueue() {
    final List<dynamic> queue =
        settingsBox.get(_syncQueueKey, defaultValue: []) as List<dynamic>;
    final typedQueue = queue.cast<Map<String, dynamic>>();
    LogService.database('Retrieved ${typedQueue.length} items from sync queue');
    return typedQueue;
  }

  static Future<void> clearSyncQueue() async {
    LogService.database('Clearing sync queue');
    await settingsBox.put(_syncQueueKey, <Map<String, dynamic>>[]);
  }

  static Future<void> removeFromSyncQueue(int index) async {
    LogService.database('Removing item at index $index from sync queue');
    final List<dynamic> queue =
        settingsBox.get(_syncQueueKey, defaultValue: []) as List<dynamic>;
    queue.removeAt(index);
    await settingsBox.put(_syncQueueKey, queue);
  }
}
