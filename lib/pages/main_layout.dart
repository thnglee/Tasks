import 'package:flutter/material.dart';
import '../widgets/custom_nav_bar.dart';
import '../theme/app_theme.dart';
import '1.dart';
import '2.dart';
import '3.dart';
import '4.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key, this.initialPage});

  final String? initialPage;

  @override
  State<MainLayout> createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  String _currentPageName = 'FirstPage';
  late final PageController _pageController = PageController(
    initialPage: [
      'FirstPage',
      'SecondPage',
      'ThirdPage',
      'FourthPage',
    ].indexOf(widget.initialPage ?? 'FirstPage'),
  );

  final List<Widget> _pages = const [
    FirstPage(),
    SecondPage(),
    ThirdPage(),
    FourthPage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handlePageChange(int index) {
    final newPageName =
        ['FirstPage', 'SecondPage', 'ThirdPage', 'FourthPage'][index];
    if (newPageName != _currentPageName) {
      setState(() {
        _currentPageName = newPageName;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = [
      'FirstPage',
      'SecondPage',
      'ThirdPage',
      'FourthPage',
    ].indexOf(_currentPageName);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
        children: [
          // Background color
          Container(
            color: isDark ? AppTheme.darkBackground : AppTheme.backgroundLight,
          ),
          // Page content
          PageView(
            controller: _pageController,
            physics: const PageScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentPageName =
                    [
                      'FirstPage',
                      'SecondPage',
                      'ThirdPage',
                      'FourthPage',
                    ][index];
              });
            },
            children: _pages,
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: currentIndex,
        onTap: _handlePageChange,
        isDark: isDark,
      ),
    );
  }
}
