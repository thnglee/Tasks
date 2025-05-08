import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../widgets/glassmorphic_scaffold.dart';

final secondPageTitleProvider = StateProvider<String>((ref) => 'Second Page');

class SecondPage extends ConsumerWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(secondPageTitleProvider);

    return GlassmorphicScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GlassmorphicContainer(
              padding: AppTheme.defaultPadding,
              child: Text(
                title,
                style: AppTheme.headlineStyle,
              ),
            ),
            const SizedBox(height: 20),
            GlassmorphicButton(
              onPressed: () {
                ref.read(secondPageTitleProvider.notifier).state = 
                  'Second Page Updated ${DateTime.now().hour}:${DateTime.now().minute}';
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Update Title',
                  style: AppTheme.buttonStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
