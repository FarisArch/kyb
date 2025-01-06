import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:kyb/pages/report.dart';

class ResultFalsePage extends StatefulWidget {
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

  @override
  _ResultFalsePageState createState() => _ResultFalsePageState();
}

String toTitleCase(String text) {
  if (text.isEmpty) return text;
  return text.split(' ').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
}

class _ResultFalsePageState extends State<ResultFalsePage> {
  String? _logoURL;

  @override
  void initState() {
    super.initState();
    _fetchLogoURL(widget.companyName); // Fetch logo URL during initialization
  }

  /// Fetch logo URL logic imported from Home page
  Future<void> _fetchLogoURL(String companyName) async {
    print('Fetching logo URL for company: $companyName');

    try {
      // Query Firestore for logo URL
      final snapshot = await FirebaseFirestore.instance.collection('barcodes').where('companyName', isEqualTo: companyName).where('approved', isEqualTo: true).where('brandType', isEqualTo: 'Recommended Brand').limit(1).get();

      if (snapshot.docs.isNotEmpty && snapshot.docs.first.data().containsKey('logoURL')) {
        final logoURL = snapshot.docs.first['logoURL'];
        if (logoURL != null && logoURL.isNotEmpty) {
          print('Logo URL found in Firestore for $companyName: $logoURL');
          setState(() {
            _logoURL = logoURL; // Use Firestore URL if available
          });
          return;
        }
      }
    } catch (e) {
      print('Error fetching logo URL for $companyName: $e');
    }

    // Fallback to external URL
    final externalUrl = _getExternalLogoUrl(companyName);
    print('Using external logo URL for $companyName: $externalUrl');
    setState(() {
      _logoURL = externalUrl;
    });
  }

  /// External logo URL generator
  String _getExternalLogoUrl(String companyName) {
    final formattedName = companyName.toLowerCase().replaceAll(' ', '');
    return 'https://img.logo.dev/$formattedName.com?token=pk_AEpg6u4jSUiuT_wJxuISUQ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo display with placeholder fallback
            _logoURL != null
                ? Image.network(
                    _logoURL!,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/placeholder_logo.png', // Placeholder logo if both URLs fail
                        height: 100,
                      );
                    },
                  )
                : const CircularProgressIndicator(), // Loading indicator while fetching

            const SizedBox(height: 20),

            // Company info
            Text(
              '${toTitleCase(widget.companyName)} is recommended!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 20),

            // Details
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
                    "Details about ${toTitleCase(widget.companyName)}\nBrand Type: ${toTitleCase(widget.brandType)}\nCategory: ${toTitleCase(widget.category)}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Buttons for Proof and Report
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (widget.link.isEmpty || widget.link == 'No evidence') {
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
                              initialUrlRequest: URLRequest(url: WebUri(widget.link)),
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
                          companyName: widget.companyName,
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
