import 'package:flutter/material.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import '1.dart';
import '2.dart';
import '3.dart';
import '4.dart';

class NavBarPage extends StatefulWidget {
  const NavBarPage({super.key, this.initialPage});

  final String? initialPage;

  @override
  State<NavBarPage> createState() => NavBarPageState();
}

class NavBarPageState extends State<NavBarPage> with SingleTickerProviderStateMixin {
  String _currentPageName = 'FirstPage';
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  
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
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handlePageChange(int index) {
    final newPageName = ['FirstPage', 'SecondPage', 'ThirdPage', 'FourthPage'][index];
    if (newPageName != _currentPageName) {
      setState(() {
        _currentPageName = newPageName;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ['FirstPage', 'SecondPage', 'ThirdPage', 'FourthPage']
        .indexOf(_currentPageName);

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: IndexedStack(
          index: currentIndex,
          children: _pages,
        ),
      ),
      extendBody: true,
      bottomNavigationBar: FloatingNavbar(
        currentIndex: currentIndex,
        onTap: _handlePageChange,
        backgroundColor: const Color(0xFFCACACA),
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0x4857636C),
        selectedBackgroundColor: const Color(0xFF4B4B54),
        borderRadius: 100.0,
        itemBorderRadius: 100.0,
        margin: const EdgeInsets.all(0.0),
        padding: const EdgeInsets.all(5.0),
        width: MediaQuery.sizeOf(context).width * 0.8,
        elevation: 3,
        items: [
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home_rounded,
                  color: currentIndex == 0 ? Colors.white : const Color(0x4857636C),
                  size: 24.0,
                ),
              ],
            ),
          ),
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  color: currentIndex == 1 ? Colors.white : const Color(0x4857636C),
                  size: 24.0,
                ),
              ],
            ),
          ),
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.settings,
                  color: currentIndex == 2 ? Colors.white : const Color(0x4857636C),
                  size: 24.0,
                ),
              ],
            ),
          ),
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  color: currentIndex == 3 ? Colors.white : const Color(0x4857636C),
                  size: 24.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 