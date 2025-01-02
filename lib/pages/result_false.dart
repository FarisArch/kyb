import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kyb/pages/pages.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ResultFalsePage extends StatelessWidget {
  final String companyName;
  final String brandType;
  final String category;
  final String link;
  final String? logoURL;

  const ResultFalsePage({
    super.key,
    required this.companyName,
    required this.brandType,
    required this.category,
    required this.link,
    this.logoURL,
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
    // Generate fallback logo URL based on company name
    final String fallbackLogoUrl = 'https://img.logo.dev/${companyName.toLowerCase().replaceAll(' ', '')}.com?token=pk_AEpg6u4jSUiuT_wJxuISUQ';

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
              logoURL?.isNotEmpty == true ? logoURL! : fallbackLogoUrl, // Prioritize logoURL, fallback if null
              height: 100,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/placeholder_logo.png', // Placeholder logo if both fail
                  height: 100,
                );
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
                    "${toTitleCase(companyName)}\nBrand Type :  ${toTitleCase(brandType)}\nCategory: ${toTitleCase(category)}.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
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
