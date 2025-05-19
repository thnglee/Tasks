import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'log_service.dart';

class SupabaseService {
  static Future<void> init() async {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> fetchAllTodos() async {
    final response = await client
        .from('tasks')
        .select()
        .eq('deleted', false)
        .order('created_at', ascending: false);
    return (response as List<dynamic>).cast<Map<String, dynamic>>();
  }

  static Future<List<Map<String, dynamic>>> fetchUpdatedTodos(
    DateTime lastSyncTime,
  ) async {
    final response = await client
        .from('tasks')
        .select()
        .gt('updated_at', lastSyncTime.toIso8601String())
        .order('created_at', ascending: false);
    return (response as List<dynamic>).cast<Map<String, dynamic>>();
  }

  static Future<bool> addTaskToSupabase(Map<String, dynamic> task) async {
    try {
      await client.from('tasks').insert(task);
      return true;
    } catch (e, st) {
      LogService.error('Supabase insert error', e, st);
      return false;
    }
  }

  static Future<bool> updateTaskInSupabase(Map<String, dynamic> task) async {
    try {
      await client.from('tasks').update(task).eq('id', task['id']);
      return true;
    } catch (e, st) {
      LogService.error('Supabase update error', e, st);
      return false;
    }
  }

  static Future<void> deleteTaskInSupabase(String id) async {
    await client.from('tasks').delete().eq('id', id);
  }

  static RealtimeChannel? _tasksChannel;

  static void listenToTasksTable({
    required void Function(Map<String, dynamic> payload) onInsert,
    required void Function(Map<String, dynamic> payload) onUpdate,
    required void Function(Map<String, dynamic> payload) onDelete,
  }) {
    // Unsubscribe previous channel if exists
    _tasksChannel?.unsubscribe();
    _tasksChannel = client.channel('public:tasks');

    _tasksChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'tasks',
          callback: (payload) {
            onInsert(payload.newRecord);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'tasks',
          callback: (payload) {
            onUpdate(payload.newRecord);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'tasks',
          callback: (payload) {
            onDelete(payload.oldRecord);
          },
        );
    _tasksChannel!.subscribe();
  }

  static void stopListeningToTasksTable() {
    _tasksChannel?.unsubscribe();
    _tasksChannel = null;
  }
}
