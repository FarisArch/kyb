// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class NavigationControl extends StatefulWidget {
  final bool isAdmin; // Pass whether the user is an admin

  const NavigationControl({Key? key, this.isAdmin = false}) : super(key: key);

  @override
  _NavigationControlState createState() => _NavigationControlState();
}

class _NavigationControlState extends State<NavigationControl> {
  int _selectedIndex = 0;

  // List of routes corresponding to the BottomNavigationBar items
  final List<String> _routes = [
    '/home',
    '/news',
    '/scan',
    '/search',
    '/contribute',
    '/admin_dashboard', // Add the admin dashboard route
  ];

  // Method to handle navigation based on selected index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pushNamed(context, _routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.home, 'Home', 0),
            _buildNavItem(Icons.article, 'News', 1),
            _buildNavItem(Icons.qr_code_scanner, 'Scan', 2),
            _buildNavItem(Icons.search, 'Search', 3),
            _buildNavItem(Icons.add_box, 'Contribute', 4),
            if (widget.isAdmin) _buildNavItem(Icons.dashboard, 'Dashboard', 5),
          ],
        ),
      ),
    );
  }

  // Helper widget to build each navigation item
  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: _selectedIndex == index ? Colors.blue : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index ? Colors.blue : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
