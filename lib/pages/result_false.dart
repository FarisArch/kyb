import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ResultFalsePage extends StatelessWidget {
  final String companyName;
  final String brandType;
  final String category;
  final String link;

  const ResultFalsePage({
    super.key,
    required this.companyName,
    required this.brandType,
    required this.category,
    required this.link,
  });

  String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ') // Split the text by spaces
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()) // Capitalize each word
        .join(' '); // Join them back with spaces
  }

  @override
  Widget build(BuildContext context) {
    // Generate logo URL based on company name
    final String logoUrl = 'https://img.logo.dev/${companyName.toLowerCase().replaceAll(' ', '')}.com?token=pk_AEpg6u4jSUiuT_wJxuISUQ';

    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
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
              '${toTitleCase(companyName)} is safe!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
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
                    "${toTitleCase(companyName)} is categorized under ${toTitleCase(category)}. Brand type: ${toTitleCase(brandType)}.\n\nEvidence: $link",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
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
                    Navigator.pop(context); // Navigate back to the previous page
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
