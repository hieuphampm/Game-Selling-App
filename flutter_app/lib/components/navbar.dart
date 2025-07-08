import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
// import '../screens/library_screen.dart';
import '../screens/community_screen.dart';
import '../screens/settings_screen.dart';

class NavBar extends StatefulWidget {
  static const routeName = '/navbar';
  const NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  final _pages = const [
    HomeScreen(),
    // LibraryScreen(),
    CommunityScreen(),
    SettingsScreen(),
  ];

  static const _bg = Color(0xFF0D0D0D);
  static const _sel = Color(0xFF60D3F3);
  static const _unsel = Color(0xFFFFD9F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _bg,
        currentIndex: _selectedIndex,
        selectedItemColor: _sel,
        unselectedItemColor: _unsel,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          // BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
