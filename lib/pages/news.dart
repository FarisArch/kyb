// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:kyb/navigation/navigation_bar.dart';
import 'package:kyb/pages/pages.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    int _currentIndex = 0;
    return Scaffold(
      bottomNavigationBar: NavigationControl(),
      backgroundColor: Color.fromRGBO(255, 220, 80, 1),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryButton('All'),
                  _buildCategoryButton('Food & Beverage'),
                  _buildCategoryButton('Fashion'),
                  _buildCategoryButton('Cosmetics'),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Using NewsCard here
            Center(
                child: Column(
              children: [
                NewsCard(),
                SizedBox(height: 30),
                NewsCard(),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String title) {
    return GestureDetector(
      onTap: () {
        print('$title button was clicked');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          title,
          style: TextStyle(
            color: Color.fromRGBO(255, 220, 80, 1),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
