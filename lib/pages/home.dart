import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kyb/navigation/navigation_bar.dart';
import 'package:kyb/pages/pages.dart';
import 'package:kyb/pages/result_false.dart';
import 'package:kyb/models/article.dart';
import 'package:kyb/pages/news_card.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

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

  List<String> _getCategoriesForToday() {
    final now = DateTime.now();
    final dayOfWeek = now.weekday;
    final random = Random(dayOfWeek);
    final shuffledCategories = List<String>.from(_categories)..shuffle(random);
    print('Selected categories for today: ${shuffledCategories.take(2).toList()}');
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
      // Fetch the document from Firestore
      final snapshot = await FirebaseFirestore.instance.collection('barcodes').where('companyName', isEqualTo: companyName).where('approved', isEqualTo: true).where('brandType', isEqualTo: 'Recommended Brand').limit(1).get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        // Check if 'logoURL' exists and is a valid URL
        if (data.containsKey('logoURL') && data['logoURL'] != null) {
          final logoURL = data['logoURL'] as String;
          if (_isValidUrl(logoURL)) {
            print('Valid logo URL found in Firestore for $companyName: $logoURL');
            return logoURL;
          } else {
            print('Invalid logo URL found in Firestore for $companyName.');
          }
        }
      }
    } catch (e) {
      print('Error fetching logoURL for $companyName: $e');
    }

    // Fallback to the external URL generator
    final fallbackUrl = _getExternalLogoUrl(null, companyName);
    print('Using fallback logo URL for $companyName: $fallbackUrl');
    return fallbackUrl;
  }

// Helper function to validate URL format
  bool _isValidUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    return uri != null && uri.hasScheme && uri.hasAuthority;
  }

  String _getExternalLogoUrl(dynamic logoData, String companyName) {
    // If logoData is a single string, return it directly
    if (logoData is String && logoData.isNotEmpty) {
      return logoData;
    }

    // If logoData is an array, return the first valid logo URL
    if (logoData is List && logoData.isNotEmpty) {
      return logoData.first; // Picks the first logo in the array
    }

    // Generate a fallback URL based on the company name
    final formattedName = companyName.toLowerCase().replaceAll(' ', '');
    return 'https://img.logo.dev/${formattedName}.com?token=pk_AEpg6u4jSUiuT_wJxuISUQ';
  }

  // Logout method
  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/front'); // Navigate to login page
    } catch (e) {
      print("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building Home widget');

    // Check if the user is logged in
    final User? user = FirebaseAuth.instance.currentUser;
    final bool isGuest = user == null; // If no user is logged in, treat as guest
    print("User is logged in: ${!isGuest}"); // Log whether the user is a guest

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 220, 80, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.white), // Exit icon button
          onPressed: _logout,
        ),
      ),
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
                                if (isGuest) {
                                  print('Guest attempted to view restricted content for company: $companyName');
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please log in to view more details.')));
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ResultFalsePage(
                                        companyName: companyName,
                                        brandType: 'Recommended Brand',
                                        category: category,
                                        link: evidenceLink,
                                      ),
                                    ),
                                  );
                                }
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
                              child: GestureDetector(
                                onTap: () {
                                  final articleUrl = articles.first.url;
                                  if (articleUrl != null && articleUrl.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Scaffold(
                                          appBar: AppBar(title: Text('News Proof')),
                                          body: InAppWebView(
                                            initialUrlRequest: URLRequest(url: WebUri(articleUrl)),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('No URL available for the news.')),
                                    );
                                  }
                                },
                                child: NewsCard(
                                  article: articles.first,
                                  backgroundColor: Colors.white,
                                ),
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
