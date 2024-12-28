import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kyb/navigation/navigation_bar.dart';
import 'package:kyb/pages/pages.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> _categories = [
    'Technology',
    'Fashion',
    'Household',
    'Cosmetics',
    'Food',
    'Healthcare',
  ];

  late final List<String> _selectedCategories = _getCategoriesForToday();

  // Method to get two categories based on the current day
  List<String> _getCategoriesForToday() {
    final now = DateTime.now();
    final dayOfWeek = now.weekday;
    final random = Random(dayOfWeek);
    final shuffledCategories = List<String>.from(_categories)..shuffle(random);
    return shuffledCategories.take(2).toList();
  }

  String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
  }

  // Fetch random companies for a specific category where approved = true
  Future<List<String>> _fetchCompanies(String category) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('barcodes')
        .where('category', isEqualTo: category)
        .where('approved', isEqualTo: true) // Only approved documents
        .limit(3)
        .get();

    return snapshot.docs.map((doc) => doc['companyName'] as String).toList();
  }

  // Fetch logo URL for a specific company where approved = true
  Future<String?> _getCompanyLogoUrl(String companyName) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('barcodes')
          .where('companyName', isEqualTo: companyName)
          .where('approved', isEqualTo: true) // Only approved documents
          .limit(5)
          .get();

      for (var doc in snapshot.docs) {
        if (doc.data().containsKey('logoURL') && doc['logoURL'] != null) {
          return doc['logoURL'] as String;
        }
      }
    } catch (e) {
      print('Error fetching logoURL: $e');
    }

    // If no logoURL found, return the external API URL
    return _getExternalLogoUrl(companyName);
  }

  // Helper to get external logo URL
  String _getExternalLogoUrl(String companyName) {
    final formattedName = companyName.toLowerCase().replaceAll(' ', '');
    return 'https://img.logo.dev/$formattedName.com?token=pk_AEpg6u4jSUiuT_wJxuISUQ';
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

              // Display selected categories and fetch companies dynamically
              for (String category in _selectedCategories) ...[
                Text(
                  category,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 10),
                FutureBuilder(
                  future: _fetchCompanies(category),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return Text(
                        'No companies available',
                        style: TextStyle(color: Colors.white),
                      );
                    }

                    final companies = snapshot.data as List<String>;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: companies.map((company) {
                        return FutureBuilder(
                          future: _getCompanyLogoUrl(company),
                          builder: (context, logoSnapshot) {
                            final logoUrl = logoSnapshot.data as String?;
                            return Column(
                              children: [
                                Text(
                                  toTitleCase(company), // Title-cased company name
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: logoUrl != null
                                      ? Image.network(
                                          logoUrl,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Center(
                                              child: Text(
                                                'No logo',
                                                style: TextStyle(color: Colors.white, fontSize: 12),
                                              ),
                                            );
                                          },
                                          fit: BoxFit.contain,
                                        )
                                      : Center(
                                          child: Text(
                                            'No logo',
                                            style: TextStyle(color: Colors.white, fontSize: 12),
                                          ),
                                        ),
                                ),
                              ],
                            );
                          },
                        );
                      }).toList(),
                    );
                  },
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
                    future: Article.fetchArticles('general'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text('Failed to load articles.'));
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No articles available.'));
                        }

                        final articles = snapshot.data!;

                        return Column(
                          children: [
                            SizedBox(
                              height: 233,
                              child: NewsCard(
                                article: articles.first, // Safely access the first article
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ],
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
