// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:kyb/pages/pages.dart';
import 'package:kyb/navigation/navigation_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationControl(),
      backgroundColor: Color.fromRGBO(255, 220, 80, 1),
      appBar: AppBar(
        title: Text("Search & Category"),
        backgroundColor: Color.fromRGBO(255, 220, 80, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search a Brand',
                labelStyle: TextStyle(color: Colors.black26),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: TextStyle(color: Colors.black),
              onChanged: (value) {
                // Handle search input if necessary
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: [
                  _buildCategoryTile(context, "Automotive", Icons.directions_car),
                  _buildCategoryTile(context, "Technology", Icons.devices),
                  _buildCategoryTile(context, "Fashion", Icons.checkroom),
                  _buildCategoryTile(context, "Manufact", Icons.factory),
                  _buildCategoryTile(context, "Store", Icons.store),
                  _buildCategoryTile(context, "Cosmetics", Icons.brush),
                  _buildCategoryTile(context, "Finance", Icons.account_balance),
                  _buildCategoryTile(context, "F&B", Icons.fastfood),
                  _buildCategoryTile(context, "Entertain", Icons.movie),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTile(BuildContext context, String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BrandListPage(category: label),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Background color of each tile
          borderRadius: BorderRadius.circular(10), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow color
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // Shadow position
            ),
          ],
        ),
        margin: EdgeInsets.all(8), // Space around each tile
        padding: EdgeInsets.all(16), // Space inside the tile
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Colors.black), // Icon color
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: Colors.black), // Text color
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder page to display a list of brands for the selected category
class BrandListPage extends StatelessWidget {
  final String category;

  const BrandListPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category Brands'),
        backgroundColor: Color.fromRGBO(255, 220, 80, 1),
      ),
      body: Center(
        child: Text('List of $category brands will be shown here'),
      ),
    );
  }
}
