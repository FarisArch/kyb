import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:kyb/pages/pages.dart';
import 'package:kyb/pages/result_false.dart';

class ResultTruePage extends StatelessWidget {
  final String companyName;
  final String brandType;
  final String category;
  final String link;

  const ResultTruePage({
    super.key,
    required this.companyName,
    required this.brandType,
    required this.category,
    required this.link,
  });

  String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
  }

  Future<String?> _getCompanyLogoUrl(String companyName) async {
    print('Fetching logo URL for company: $companyName');
    try {
      // Fetch document from Firestore
      final snapshot = await FirebaseFirestore.instance.collection('barcodes').where('companyName', isEqualTo: companyName).where('approved', isEqualTo: true).where('brandType', isEqualTo: 'Recommended Brand').limit(1).get();

      // Check if the snapshot contains a document
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();

        // Check if 'logoURL' field is present and valid
        if (data.containsKey('logoURL') && data['logoURL'] != null) {
          final logoURL = data['logoURL'] as String;
          print('Found logoURL in Firestore: $logoURL');
          if (_isValidUrl(logoURL)) {
            print('Valid logo URL found in Firestore for $companyName: $logoURL');
            return logoURL; // Return valid Firestore URL
          } else {
            print('Invalid logo URL in Firestore for $companyName.');
          }
        }
      }
    } catch (e) {
      print('Error fetching logoURL for $companyName: $e');
    }

    // Fallback to external URL generator
    final fallbackUrl = _getExternalLogoUrl(companyName);
    print('Using fallback logo URL for $companyName: $fallbackUrl');
    return fallbackUrl; // Return fallback URL
  }

  String _getExternalLogoUrl(String companyName) {
    // Handle company names with apostrophes or special characters
    final formattedName = companyName.toLowerCase().replaceAll(RegExp(r"[^a-z0-9]+"), "");
    return 'https://img.logo.dev/${formattedName}.com?token=pk_AEpg6u4jSUiuT_wJxuISUQ';
  }

  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  Future<List<Map<String, dynamic>>> fetchAlternativeBrands() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('barcodes').where('category', isEqualTo: category).where('brandType', isEqualTo: 'Recommended Brand').get();

      final brands = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      if (brands.isEmpty) {
        debugPrint('No brands found in barcodes collection for category: $category');
        return [];
      }

      brands.shuffle();
      return brands.take(3).toList();
    } catch (e) {
      debugPrint('Error fetching brands: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<String?>(
              future: _getCompanyLogoUrl(companyName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Failed to load logo');
                } else if (snapshot.hasData && snapshot.data != null) {
                  final logoUrl = snapshot.data!;
                  return Image.network(
                    logoUrl,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100,
                        width: 100,
                        alignment: Alignment.center,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                      );
                    },
                  );
                } else {
                  return const Text('No logo available');
                }
              },
            ),
            const SizedBox(height: 20),
            Text(
              '${toTitleCase(companyName)} is not recommended!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    "Details about ${toTitleCase(companyName)}\nBrand Type: ${toTitleCase(brandType)}\nCategory: ${toTitleCase(category)}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchAlternativeBrands(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return const Text('Failed to load alternative brands.');
                }

                final alternativeBrands = snapshot.data ?? [];

                if (alternativeBrands.isEmpty) {
                  return const Text('No alternative brands available.');
                }

                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Recommended Alternatives:',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        itemCount: alternativeBrands.length,
                        itemBuilder: (context, index) {
                          final brand = alternativeBrands[index];
                          final brandName = brand['companyName'] ?? 'Unknown';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResultFalsePage(
                                    companyName: brandName,
                                    brandType: brand['brandType'] ?? 'Unknown',
                                    category: brand['category'] ?? 'Unknown',
                                    link: brand['link'] ?? 'No link',
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                FutureBuilder<String?>(
                                  future: _getCompanyLogoUrl(brandName), // Use _getCompanyLogoUrl for each alternative brand
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return const Icon(Icons.image_not_supported, size: 60, color: Colors.grey);
                                    } else if (snapshot.hasData && snapshot.data != null) {
                                      final logoUrl = snapshot.data!;
                                      return Image.network(
                                        logoUrl,
                                        height: 60,
                                        width: 60,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            height: 60,
                                            width: 60,
                                            alignment: Alignment.center,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                                          );
                                        },
                                      );
                                    } else {
                                      return const Icon(Icons.image_not_supported, size: 60, color: Colors.grey);
                                    }
                                  },
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  toTitleCase(brandName),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (link.isEmpty || link == 'No evidence') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No link available for proof.')),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(title: const Text('Proof')),
                            body: InAppWebView(
                              initialUrlRequest: URLRequest(url: WebUri(link)),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('View Proof'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportPage(
                          companyName: companyName,
                        ),
                      ),
                    );
                  },
                  child: const Text('Report'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
