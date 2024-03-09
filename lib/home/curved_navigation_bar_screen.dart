// curved_navigation_bar_screen.dart
import 'package:diabetic/home/ana.dart';
import 'package:diabetic/home/profilpage.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CurvedNavigationBarScreen extends StatefulWidget {
  @override
  _CurvedNavigationBarScreenState createState() => _CurvedNavigationBarScreenState();
}

class _CurvedNavigationBarScreenState extends State<CurvedNavigationBarScreen> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _pages = [
    HomePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _pageIndex,
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: Colors.purple.shade50,
        color: Colors.deepPurple.shade400,
        animationDuration: Duration(milliseconds: 300),
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.person, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }
}
