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
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkSurface : AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color:
                    isDark
                        ? Colors.white.withOpacity(0.15)
                        : Colors.black.withOpacity(0.25),
                offset: const Offset(
                  0,
                  0,
                ), // Shadow position: right under the nav bar
                blurRadius: 8,
                spreadRadius: 0, // Keeps the glow concentrated
              ),
              // Additional inner glow for dark mode
              if (isDark)
                BoxShadow(
                  color: Colors.white.withOpacity(0.05),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home_rounded, 0),
              _buildNavItem(Icons.history_rounded, 1),
              _buildNavItem(Icons.settings_rounded, 2),
              _buildNavItem(Icons.person_rounded, 3),
            ],
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
        decoration:
            isSelected
                ? BoxDecoration(
                  color: AppTheme.primaryPurple,
                  borderRadius: BorderRadius.circular(16),
                )
                : null,
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
