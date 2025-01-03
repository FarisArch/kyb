import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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

class _ResultFalsePageState extends State<ResultFalsePage> {
  String? _logoURL;

  @override
  void initState() {
    super.initState();
    _getCompanyLogoUrl(widget.companyName); // Fetch the logo URL when the page is initialized
  }

  Future<void> _getCompanyLogoUrl(String companyName) async {
    print('Fetching logo URL for company: $companyName');
    try {
      final snapshot = await FirebaseFirestore.instance.collection('barcodes').where('companyName', isEqualTo: companyName).where('approved', isEqualTo: true).where('brandType', isEqualTo: 'Recommended Brand').limit(1).get();

      if (snapshot.docs.isNotEmpty && snapshot.docs.first.data().containsKey('logoURL')) {
        final logoURL = snapshot.docs.first['logoURL'];
        if (logoURL != null) {
          print('Logo URL found in Firestore for $companyName: $logoURL');
          setState(() {
            _logoURL = logoURL; // Set the fetched logo URL to state
          });
        }
      } else {
        final externalUrl = _getExternalLogoUrl(companyName);
        setState(() {
          _logoURL = externalUrl; // Set the fallback URL if no logo is found in Firestore
        });
        print('Using external logo URL for $companyName: $externalUrl');
      }
    } catch (e) {
      print('Error fetching logo URL for $companyName: $e');
    }
  }

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
        title: Text(widget.companyName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _logoURL != null
                ? Image.network(
                    _logoURL!,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/placeholder_logo.png', // Placeholder logo if both fail
                        height: 100,
                      );
                    },
                  )
                : const CircularProgressIndicator(), // Show loading indicator if logoURL is null
            const SizedBox(height: 20),
            Text(
              '${widget.companyName} is recommended!',
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
                    "Details about ${widget.companyName}\nBrand Type: ${widget.brandType}\nCategory: ${widget.category}",
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
