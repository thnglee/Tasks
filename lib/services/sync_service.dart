import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/hive_service.dart';
import '../services/supabase_service.dart';
import '../services/log_service.dart';
import '../todo_model.dart';
import '../providers/todo_provider.dart';

final syncStateProvider = StateProvider<bool>((ref) => false);

class SyncService {
  static Future<void> checkFirstLaunchAndSync(WidgetRef ref) async {
    if (HiveService.getIsFirstLaunch()) {
      ref.read(syncStateProvider.notifier).state = true;
      LogService.sync('Starting first launch sync');
      try {
        final todosData = await SupabaseService.fetchAllTodos();
        LogService.sync('Initial sync: fetched ${todosData.length} tasks');

        for (final todoMap in todosData) {
          final todo = Todo.fromMap(todoMap);
          await HiveService.addTodo(todo);
        }

        LogService.database('Stored ${todosData.length} tasks locally');
        await HiveService.setIsFirstLaunch(false);
        ref.invalidate(todoProvider);
        LogService.sync('Initial sync completed');
      } catch (e, st) {
        LogService.error('Initial sync failed', e, st);
      } finally {
        ref.read(syncStateProvider.notifier).state = false;
      }
    }
  }

  static Future<void> syncUpdatedTasks(WidgetRef ref) async {
    ref.read(syncStateProvider.notifier).state = true;
    LogService.sync('Starting incremental sync');

    try {
      final lastSyncTime =
          HiveService.getLastSyncTime() ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final updatedTodosData = await SupabaseService.fetchUpdatedTodos(
        lastSyncTime,
      );

      if (updatedTodosData.isNotEmpty) {
        LogService.sync('Found ${updatedTodosData.length} updates');

        for (final todoMap in updatedTodosData) {
          final todo = Todo.fromMap(todoMap);
          await HiveService.addTodo(todo);
        }

        await HiveService.setLastSyncTime(DateTime.now().toUtc());
        ref.invalidate(todoProvider);
        LogService.sync('Incremental sync completed');
      } else {
        LogService.debug('No updates found');
      }
    } catch (e, st) {
      LogService.error('Sync failed', e, st);
    } finally {
      ref.read(syncStateProvider.notifier).state = false;
    }
  }

  static Future<void> processSyncQueue(WidgetRef ref) async {
    final queue = HiveService.getSyncQueue();
    if (queue.isEmpty) return;

    LogService.sync('Processing queue: ${queue.length} items');

    for (int i = 0; i < queue.length;) {
      final change = queue[i];
      final action = change['action'] as String;
      final task = change['task'] as Map<String, dynamic>;

      try {
        bool success = false;
        switch (action) {
          case 'add':
            success = await SupabaseService.addTaskToSupabase(task);
            if (success) LogService.database('Added task ${task['id']}');
            break;
          case 'update':
          case 'delete':
            success = await SupabaseService.updateTaskInSupabase(task);
            if (success)
              LogService.database(
                '${action.toUpperCase()}: task ${task['id']}',
              );
            break;
        }

        if (success) {
          await HiveService.removeFromSyncQueue(i);
        } else {
          LogService.error('Failed to sync task ${task['id']}', null, null);
        }
      } catch (e, st) {
        LogService.error('Failed to sync task ${task['id']}', e, st);
      }
    }
  }

  static void listenToConnectivity(WidgetRef ref) {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        LogService.network('Connection restored');
        processSyncQueue(ref);
      } else {
        LogService.network('Connection lost');
      }
    });
  }
}
