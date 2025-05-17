import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static Future<void> init() async {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> fetchAllTodos() async {
    final response = await client.from('tasks').select().then((data) => data);
    return (response as List<dynamic>).cast<Map<String, dynamic>>();
  }

  static Future<List<Map<String, dynamic>>> fetchUpdatedTodos(DateTime lastSyncTime) async {
    final response = await client
        .from('tasks')
        .select()
        .gt('updated_at', lastSyncTime.toIso8601String());
    return (response as List<dynamic>).cast<Map<String, dynamic>>();
  }

  static Future<void> addTaskToSupabase(Map<String, dynamic> task) async {
    await client.from('tasks').insert(task);
  }

  static Future<void> updateTaskInSupabase(Map<String, dynamic> task) async {
    await client.from('tasks').update(task).eq('id', task['id']);
  }

  static Future<void> deleteTaskInSupabase(String id) async {
    await client.from('tasks').delete().eq('id', id);
  }
} 