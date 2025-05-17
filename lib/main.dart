import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/nav_bar_page.dart';
import 'theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'services/hive_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/supabase_service.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Main');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('[\u001b[36m\u001b[1m\u001b[0m${record.level.name}] ${record.time}: ${record.loggerName}: ${record.message}');
  });
  _logger.info('SUPABASE_URL: ${dotenv.env['SUPABASE_URL'] ?? 'NOT FOUND'}');
  _logger.info('SUPABASE_ANON_KEY: ${(dotenv.env['SUPABASE_ANON_KEY']?.substring(0, 8) ?? 'NOT FOUND')}...');
  await HiveService.init();
  await SupabaseService.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    
    return MaterialApp(
      title: 'Riverpod Todo List',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const NavBarPage(),
    );
  }
}
