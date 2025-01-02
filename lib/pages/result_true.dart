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
    final String logoUrl = 'https://img.logo.dev/${companyName.toLowerCase().replaceAll(' ', '')}.com?token=pk_AEpg6u4jSUiuT_wJxuISUQ';

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
            Image.network(
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
            ),
            const SizedBox(height: 20),
            Text(
              '${toTitleCase(companyName)} is boycotted!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
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
                    "Details about ${toTitleCase(companyName)}'s boycott regarding ${toTitleCase(brandType)} in the ${toTitleCase(category)} category. Link for proof: $link",
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
                    color: Colors.blue[50],
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
                          final altLogoUrl = 'https://img.logo.dev/${(brand['companyName'] ?? 'unknown').toLowerCase().replaceAll(' ', '')}.com?token=pk_AEpg6u4jSUiuT_wJxuISUQ';
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResultFalsePage(
                                    companyName: brand['companyName'] ?? 'Unknown',
                                    brandType: brand['brandType'] ?? 'Unknown',
                                    category: brand['category'] ?? 'Unknown',
                                    link: brand['link'] ?? 'No link',
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.network(
                                  altLogoUrl,
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
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  toTitleCase(brand['companyName'] ?? 'Unknown'),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
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
