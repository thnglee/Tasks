import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../widgets/glassmorphic_scaffold.dart';

final fourthPageColorProvider = StateProvider<Color>((ref) => AppTheme.primaryGrey);

class FourthPage extends ConsumerWidget {
  const FourthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentColor = ref.watch(fourthPageColorProvider);

    return GlassmorphicScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GlassmorphicContainer(
              padding: AppTheme.defaultPadding,
              backgroundColor: currentColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Fourth Page',
                    style: AppTheme.headlineStyle,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tap buttons to change color',
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
                    ref.read(fourthPageColorProvider.notifier).state = AppTheme.lightGrey;
                  },
                  backgroundColor: AppTheme.lightGrey,
                  child: const SizedBox(width: 40, height: 40),
                ),
                const SizedBox(width: 20),
                GlassmorphicButton(
                  onPressed: () {
                    ref.read(fourthPageColorProvider.notifier).state = AppTheme.primaryGrey;
                  },
                  backgroundColor: AppTheme.primaryGrey,
                  child: const SizedBox(width: 40, height: 40),
                ),
                const SizedBox(width: 20),
                GlassmorphicButton(
                  onPressed: () {
                    ref.read(fourthPageColorProvider.notifier).state = AppTheme.darkGrey;
                  },
                  backgroundColor: AppTheme.darkGrey,
                  child: const SizedBox(width: 40, height: 40),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
