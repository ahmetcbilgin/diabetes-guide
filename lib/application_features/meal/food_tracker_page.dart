import 'package:flutter/material.dart';
import 'save_meal_screen.dart'; 
import 'show_saved_meals_screen.dart'; 

class FoodTrackerPage extends StatefulWidget {
  @override
  _FoodTrackerPageState createState() => _FoodTrackerPageState();
}

class _FoodTrackerPageState extends State<FoodTrackerPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    SaveMealScreen(), 
    ShowSavedMealsScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.save),
            label: 'Öğün Kaydet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            label: 'Kaydedilenler',
          ),
        ],
      ),
    );
  }
}
