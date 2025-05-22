import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isDark;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the width of each nav item section
    final navWidth =
        MediaQuery.of(context).size.width - 48.0; // Total width minus padding
    final itemWidth = navWidth / 4; // Divide by number of items

    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
        child: Material(
          elevation: isDark ? 0 : 8,
          borderRadius: BorderRadius.circular(24),
          color: Colors.transparent,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurface : AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              children: [
                // Animated Selection Indicator
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  left: currentIndex * itemWidth + (itemWidth - 48) / 2,
                  top: 8.0,
                  child: Container(
                    width: 48,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                // Nav Items
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(Icons.home_rounded, 0),
                    _buildNavItem(Icons.history_rounded, 1),
                    _buildNavItem(Icons.settings_rounded, 2),
                    _buildNavItem(Icons.person_rounded, 3),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 48,
        height: 32,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Icon(
          icon,
          color:
              isSelected
                  ? Colors.white
                  : (isDark
                      ? AppTheme.textLight.withOpacity(0.5)
                      : AppTheme.textDark.withOpacity(0.5)),
          size: 18,
        ),
      ),
    );
  }
}
