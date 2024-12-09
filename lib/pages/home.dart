import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kyb/navigation/navigation_bar.dart'; // Ensure this file has your navigation bar widget
import 'package:kyb/pages/pages.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> _categories = [
    'Automotive',
    'Fashion',
    'Technology',
    'Manufacturer',
    'Supermarket',
    'Cosmetics',
    'Finance',
    'F&B',
    'Entertainment',
  ];

  late final List<String> _selectedCategories = _getCategoriesForToday();

  // Method to get two categories based on the current day of the week
  List<String> _getCategoriesForToday() {
    final now = DateTime.now();
    final dayOfWeek = now.weekday; // Monday = 1, Sunday = 7
    final random = Random(dayOfWeek); // Seed random with the day of the week

    // Shuffle the list based on the seeded random
    final shuffledCategories = List<String>.from(_categories)..shuffle(random);

    // Return the first two categories
    return shuffledCategories.take(2).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 220, 80, 1),
      bottomNavigationBar: NavigationControl(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Text(
                    'Support Local-la!',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 220, 80, 1),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Display selected categories
              for (String category in _selectedCategories) ...[
                Text(
                  category,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    3, // Display 3 items for each category
                    (index) => Column(
                      children: [
                        Text('item ${index + 1}'),
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: TextButton(
                            onPressed: () {
                              print('Clicked on ${category} item ${index + 1}');
                            },
                            child: Image.asset('assets/1.jpg'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],

              // Flash news
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Text(
                      'Flash news',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 220, 80, 1),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: Article.fetchArticles('general'), // Fetch general news
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final articles = snapshot.data;
                        return Column(
                          children: articles != null
                              ? [
                                  SizedBox(
                                    height: 233,
                                    child: NewsCard(
                                      article: articles.first,
                                      backgroundColor: Colors.white,
                                    ),
                                  )
                                ]
                              : [],
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
