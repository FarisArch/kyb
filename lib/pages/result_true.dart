import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kyb/pages/pages.dart';

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

  Future<List<Map<String, dynamic>>> fetchAlternativeBrands() async {
    // Fetch alternative brands from Firestore where category and brandType match
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('brands') // Replace 'brands' with your Firestore collection name
        .where('category', isEqualTo: category)
        .where('brandType', isEqualTo: 'Recommended Brand')
        .get();

    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Generate logo URL based on company name
    final String logoUrl = 'https://img.logo.dev/${companyName.toLowerCase().replaceAll(' ', '')}.com?token=pk_AEpg6u4jSUiuT_wJxuISUQ';

    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(companyName),
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
                return const Text('No logo available');
              },
            ),
            const SizedBox(height: 20),
            Text(
              '$companyName is boycotted!',
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
                    "Details about $companyName's boycott regarding $brandType in the $category category. Link for proof: $link",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ...alternativeBrands.map((brand) {
                        return ListTile(
                          leading: brand['logoUrl'] != null
                              ? Image.network(
                            brand['logoUrl'],
                            width: 40,
                            height: 40,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported),
                          )
                              : const Icon(Icons.image),
                          title: Text(brand['name'] ?? 'Unknown Brand'),
                          subtitle: Text('Category: ${brand['category']}'),
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Proof for $companyName'),
                          content: Text('Proof link: $link'),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('View proof'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReportPage()),
                    );
                  },
                  child: const Text('Report'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: 'Logos provided by ',
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Logo.dev',
                    style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()..onTap = () async {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
