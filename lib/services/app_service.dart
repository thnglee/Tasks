import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'hive_service.dart';
import 'supabase_service.dart';
import 'log_service.dart';
import 'sync_service.dart';

class AppService {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Initialize logging first
      LogService.init();
      LogService.info('Starting app initialization...');

      // Load environment variables
      await dotenv.load();
      LogService.debug('Environment variables loaded');

      // Initialize local storage
      await HiveService.init();
      LogService.debug('Local storage initialized');

      // Initialize Supabase
      await SupabaseService.init();
      LogService.debug('Supabase client initialized');

      _initialized = true;
      LogService.info('App initialization completed');
    } catch (e, st) {
      LogService.error('Failed to initialize app', e, st);
      rethrow;
    }
  }

  static Future<void> initializeSync(WidgetRef ref) async {
    try {
      // Set up network connectivity listener
      SyncService.listenToConnectivity(ref);

      // Check first launch and perform initial sync if needed
      if (HiveService.getIsFirstLaunch()) {
        LogService.info('First launch detected, performing initial sync');
        await SyncService.checkFirstLaunchAndSync(ref);
      } else {
        LogService.debug('Not first launch, checking for updates');
        await SyncService.syncUpdatedTasks(ref);
      }
    } catch (e, st) {
      LogService.error('Failed to initialize sync', e, st);
    }
  }
}
