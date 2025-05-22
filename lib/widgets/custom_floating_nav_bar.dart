import 'package:flutter/material.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import '../theme/app_theme.dart';

class CustomFloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isDark;

  const CustomFloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Account for horizontal padding in width calculation
    final horizontalPadding = 32.0; // 16.0 on each side
    final navBarWidth = (screenWidth - horizontalPadding) * 0.85;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Center(
        child: SizedBox(
          width: navBarWidth,
          child: FloatingNavbar(
            currentIndex: currentIndex,
            onTap: onTap,
            backgroundColor:
                isDark ? AppTheme.darkSurface : AppTheme.surfaceLight,
            selectedItemColor: Colors.white,
            unselectedItemColor:
                isDark
                    ? AppTheme.textLight.withOpacity(0.5)
                    : AppTheme.textDark.withOpacity(0.5),
            selectedBackgroundColor: AppTheme.primaryPurple,
            borderRadius: 24.0,
            itemBorderRadius: 24.0,
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            elevation: isDark ? 0 : 4,
            items: [
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

  FloatingNavbarItem _buildNavItem(IconData icon, int index) {
    return FloatingNavbarItem(
      customWidget: Center(
        child: Icon(
          icon,
          color:
              currentIndex == index
                  ? Colors.white
                  : (isDark
                      ? AppTheme.textLight.withOpacity(0.5)
                      : AppTheme.textDark.withOpacity(0.5)),
          size: 16.0,
        ),
      ),
    );
  }
}
