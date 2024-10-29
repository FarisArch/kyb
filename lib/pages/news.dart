// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
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
      bottomNavigationBar: NavigationBar(
        height: 60,
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsPage(),
              ),
            );
          }
          setState(() => _currentIndex = index);
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          NavigationDestination(
            icon: Icon(Icons.camera),
            label: 'Scan',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_a_photo),
            label: 'Contribute',
          ),
        ],
      ),
      backgroundColor: Color.fromRGBO(238, 206, 77, 100),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
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
            SizedBox(height: 10),

            // Using NewsCard here
            Center(
                child: Column(
              children: [
                NewsCard(),
                SizedBox(
                  height: 5,
                ),
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
            color: Color.fromRGBO(238, 206, 77, 100),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
