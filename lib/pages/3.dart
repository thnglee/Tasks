import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../widgets/glassmorphic_scaffold.dart';

final thirdPageCounterProvider = StateProvider<int>((ref) => 0);

class ThirdPage extends ConsumerWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(thirdPageCounterProvider);

    return GlassmorphicScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GlassmorphicContainer(
              padding: AppTheme.defaultPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Third Page',
                    style: AppTheme.headlineStyle,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Counter: $counter',
                    style: AppTheme.bodyStyle,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GlassmorphicButton(
                  onPressed: () {
                    ref.read(thirdPageCounterProvider.notifier).state--;
                  },
                  child: const Icon(
                    Icons.remove,
                    color: AppTheme.white,
                  ),
                ),
                const SizedBox(width: 20),
                GlassmorphicButton(
                  onPressed: () {
                    ref.read(thirdPageCounterProvider.notifier).state++;
                  },
                  child: const Icon(
                    Icons.add,
                    color: AppTheme.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
