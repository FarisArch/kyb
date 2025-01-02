import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kyb/navigation/navigation_bar.dart';
import 'package:kyb/pages/pages.dart';
import 'package:kyb/pages/result_false.dart';
import 'package:kyb/models/article.dart';
import 'package:kyb/pages/news_card.dart';

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
    print('Selected categories for today: \${shuffledCategories.take(2).toList()}');
    return shuffledCategories.take(2).toList();
  }

  String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
  }

  Future<List<Map<String, dynamic>>> _fetchCompanies(String category) async {
    print('Fetching companies for category: $category');
    try {
      final snapshot = await FirebaseFirestore.instance.collection('barcodes').where('category', isEqualTo: category.toLowerCase()).where('approved', isEqualTo: true).where('brandType', isEqualTo: 'Recommended Brand').limit(3).get();

      if (snapshot.docs.isEmpty) {
        print('No companies found for category: $category');
      }

      final companies = snapshot.docs.map((doc) {
        return {
          'companyName': doc['companyName'] as String,
          'evidenceLink': doc['evidenceLink'] ?? 'No evidence link',
        };
      }).toList();

      print('Fetched companies: $companies');
      return companies;
    } catch (e) {
      print('Error fetching companies for category $category: $e');
      return [];
    }
  }

  Future<String?> _getCompanyLogoUrl(String companyName) async {
    print('Fetching logo URL for company: $companyName');
    try {
      final snapshot = await FirebaseFirestore.instance.collection('barcodes').where('companyName', isEqualTo: companyName).where('approved', isEqualTo: true).where('brandType', isEqualTo: 'Recommended Brand').limit(1).get();

      if (snapshot.docs.isNotEmpty && snapshot.docs.first.data().containsKey('logoURL')) {
        final logoURL = snapshot.docs.first['logoURL'];
        if (logoURL != null) {
          print('Logo URL found in Firestore for $companyName: $logoURL');
          return logoURL;
        }
      }
    } catch (e) {
      print('Error fetching logoURL for $companyName: $e');
    }

    final externalUrl = _getExternalLogoUrl(companyName);
    print('Using external logo URL for $companyName: $externalUrl');
    return externalUrl;
  }

  String _getExternalLogoUrl(String companyName) {
    final formattedName = companyName.toLowerCase().replaceAll(' ', '');
    return 'https://img.logo.dev/${formattedName}.com?token=pk_AEpg6u4jSUiuT_wJxuISUQ';
  }

  @override
  Widget build(BuildContext context) {
    print('Building Home widget');
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 220, 80, 1),
      bottomNavigationBar: NavigationControl(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                    } else if (snapshot.hasError || !snapshot.hasData || (snapshot.data as List<Map<String, dynamic>>).isEmpty) {
                      return Text(
                        'No companies available',
                        style: TextStyle(color: Colors.white),
                      );
                    }

                    final companies = snapshot.data as List<Map<String, dynamic>>;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: companies.map((companyData) {
                        final companyName = companyData['companyName'] as String;
                        final evidenceLink = companyData['evidenceLink'] as String;

                        return FutureBuilder(
                          future: _getCompanyLogoUrl(companyName),
                          builder: (context, logoSnapshot) {
                            final logoUrl = logoSnapshot.data as String?;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResultFalsePage(
                                            companyName: companyName,
                                            brandType: 'Recommended Brand',
                                            category: category,
                                            link: evidenceLink,
                                          )),
                                );
                              },
                              child: Column(
                                children: [
                                  Text(
                                    toTitleCase(companyName),
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: logoUrl != null
                                        ? Image.network(
                                            logoUrl,
                                            fit: BoxFit.contain,
                                          )
                                        : Text('No logo', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
              Column(
                children: [
                  SizedBox(height: 10),
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
                    future: Article.fetchArticles(page: 1),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final articles = snapshot.data!;
                        return Column(
                          children: [
                            SizedBox(
                              height: 233,
                              child: NewsCard(
                                article: articles.first,
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
