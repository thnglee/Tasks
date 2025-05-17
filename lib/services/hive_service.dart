import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../todo_model.dart';

class HiveService {
  static const String _todoBoxName = 'todos'; 
  static const String _settingsBoxName = 'settings';
  static const String _themeModeKey = 'themeMode';
  static const String _lastSyncTimeKey = 'lastSyncTime';
  static const String _isFirstLaunchKey = 'isFirstLaunch';
  static const String _syncQueueKey = 'syncQueue';

  static Future<void> init() async {
    if (kIsWeb) {
      await Hive.initFlutter();
    } else {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocumentDir.path);
    }
    Hive.registerAdapter(TodoAdapter());
    await Hive.openBox<Todo>(_todoBoxName);
    await Hive.openBox(_settingsBoxName);
  }

  static Box<Todo> get todoBox => Hive.box<Todo>(_todoBoxName);

  static Box get settingsBox => Hive.box(_settingsBoxName);

  static Future<void> addTodo(Todo todo) async {
    await todoBox.put(todo.id, todo);
  }

  static Future<void> updateTodo(Todo todo) async {
    await todoBox.put(todo.id, todo);
  }

  static Future<void> deleteTodo(String id) async {
    await todoBox.delete(id);
  }

  static List<Todo> getAllTodos() {
    return todoBox.values.toList();
  }

  static Future<void> clearAllTodos() async {
    await todoBox.clear();
  }

  static Future<void> setThemeMode(String mode) async {
    await settingsBox.put(_themeModeKey, mode);
  }

  static String? getThemeMode() {
    return settingsBox.get(_themeModeKey) as String?;
  }

  static Future<void> setLastSyncTime(DateTime time) async {
    await settingsBox.put(_lastSyncTimeKey, time.toIso8601String());
  }

  static DateTime? getLastSyncTime() {
    final value = settingsBox.get(_lastSyncTimeKey) as String?;
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  static Future<void> setIsFirstLaunch(bool value) async {
    await settingsBox.put(_isFirstLaunchKey, value);
  }

  static bool getIsFirstLaunch() {
    final value = settingsBox.get(_isFirstLaunchKey);
    if (value == null) return true; // Default to true if not set
    return value as bool;
  }

  // Sync Queue Methods
  static Future<void> addToSyncQueue(Map<String, dynamic> change) async {
    final List<dynamic> queue = settingsBox.get(_syncQueueKey, defaultValue: []) as List<dynamic>;
    queue.add(change);
    await settingsBox.put(_syncQueueKey, queue);
  }

  static List<Map<String, dynamic>> getSyncQueue() {
    final List<dynamic> queue = settingsBox.get(_syncQueueKey, defaultValue: []) as List<dynamic>;
    return queue.cast<Map<String, dynamic>>();
  }

  static Future<void> clearSyncQueue() async {
    await settingsBox.put(_syncQueueKey, <Map<String, dynamic>>[]);
  }

  static Future<void> removeFromSyncQueue(int index) async {
    final List<dynamic> queue = settingsBox.get(_syncQueueKey, defaultValue: []) as List<dynamic>;
    queue.removeAt(index);
    await settingsBox.put(_syncQueueKey, queue);
  }
} 