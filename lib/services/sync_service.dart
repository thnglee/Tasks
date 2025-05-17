import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../services/hive_service.dart';
import '../services/supabase_service.dart';
import '../todo_model.dart';
import '../providers/todo_provider.dart';

final syncStateProvider = StateProvider<bool>((ref) => false);
final _logger = Logger('SyncService');

class SyncService {
  static Future<void> checkFirstLaunchAndSync(WidgetRef ref) async {
    if (HiveService.getIsFirstLaunch()) {
      ref.read(syncStateProvider.notifier).state = true;
      _logger.info('Starting first launch sync...');
      try {
        final todosData = await SupabaseService.fetchAllTodos();
        _logger.info('Fetched \\${todosData.length} tasks from Supabase.');
        for (final todoMap in todosData) {
          final todo = Todo.fromMap(todoMap);
          await HiveService.addTodo(todo);
        }
        _logger.info('Stored all tasks in Hive.');
        await HiveService.setIsFirstLaunch(false);
        ref.invalidate(todoProvider);
        _logger.info('First launch sync complete, provider invalidated.');
      } catch (e, st) {
        _logger.severe('Error fetching or storing tasks from Supabase: $e', e, st);
      } finally {
        ref.read(syncStateProvider.notifier).state = false;
        _logger.info('First launch sync loading state set to false.');
      }
    }
  }

  static Future<void> syncUpdatedTasks(WidgetRef ref) async {
    ref.read(syncStateProvider.notifier).state = true;
    _logger.info('Starting delta sync...');
    try {
      final lastSyncTime = HiveService.getLastSyncTime() ?? DateTime.fromMillisecondsSinceEpoch(0);
      final updatedTodosData = await SupabaseService.fetchUpdatedTodos(lastSyncTime);
      _logger.info('Fetched \\${updatedTodosData.length} updated tasks from Supabase.');
      for (final todoMap in updatedTodosData) {
        final todo = Todo.fromMap(todoMap);
        await HiveService.addTodo(todo);
      }
      _logger.info('Stored updated tasks in Hive.');
      await HiveService.setLastSyncTime(DateTime.now().toUtc());
      ref.invalidate(todoProvider);
      _logger.info('Delta sync complete, provider invalidated.');
    } catch (e, st) {
      _logger.severe('Error syncing updated tasks from Supabase: $e', e, st);
    } finally {
      ref.read(syncStateProvider.notifier).state = false;
      _logger.info('Delta sync loading state set to false.');
    }
  }

  static Future<void> processSyncQueue(WidgetRef ref) async {
    final queue = HiveService.getSyncQueue();
    for (int i = 0; i < queue.length; i++) {
      final change = queue[i];
      final action = change['action'] as String;
      final task = change['task'] as Map<String, dynamic>;
      try {
        if (action == 'add') {
          await SupabaseService.addTaskToSupabase(task);
        } else if (action == 'update') {
          await SupabaseService.updateTaskInSupabase(task);
        } else if (action == 'delete') {
          await SupabaseService.updateTaskInSupabase(task);
        }
        await HiveService.removeFromSyncQueue(i);
        _logger.info('Processed and removed sync queue item: $action');
      } catch (e) {
        _logger.severe('Failed to sync queued change: $e');
      }
    }
  }

  static void listenToConnectivity(WidgetRef ref) {
    final connectivity = Connectivity();
    connectivity.onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        _logger.info('Connectivity restored, processing sync queue.');
        processSyncQueue(ref);
      }
    });
  }
} 