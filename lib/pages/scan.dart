import 'package:flutter/material.dart';
import 'package:kyb/pages/pages.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kyb/navigation/navigation_bar.dart';
import 'package:collection/collection.dart';
import 'package:kyb/pages/result_true.dart';
import 'package:kyb/pages/result_false.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String _scanResult = '';

  final pages = [
    Home(),
    NewsPage(),
    ScanPage(),
  ];

  Future<void> _scanBarcode() async {
    try {
      final ScanResult barcodeScanRes = await BarcodeScanner.scan();
      setState(() {
        _scanResult = barcodeScanRes.rawContent;
      });

      // Check Firestore for barcode existence
      final querySnapshot = await FirebaseFirestore.instance.collection('barcodes').where('barcodeNum', isEqualTo: _scanResult).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Barcode exists in Firestore
        final doc = querySnapshot.docs.first;
        final brandType = doc['brandType'];
        final companyName = doc['companyName'];
        final category = doc['category'];
        final evidenceLink = doc['evidenceLink'] ?? 'No evidence';

        if (brandType == 'Recommended Brand') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultFalsePage(
                companyName: companyName,
                brandType: brandType,
                category: category,
                link: evidenceLink,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultTruePage(
                companyName: companyName,
                brandType: brandType,
                category: category,
                link: evidenceLink,
              ),
            ),
          );
        }
      } else {
        // Fetch brand and category details from the web
        final url = 'https://go-upc.com/search?q=$_scanResult';
        final response = await http.get(Uri.parse(url));

        String brandName = '';
        String categoryName = '';

        if (response.statusCode == 200) {
          final document = parse(response.body);

          // Extract Brand
          final brandElement = document.querySelectorAll('tr').firstWhereOrNull(
                (element) => element.querySelector('td')?.text.contains('Brand') ?? false,
              );

          if (brandElement != null) {
            brandName = brandElement.querySelectorAll('td')[1]?.text.trim() ?? '';
          } else {
            print('Brand not found.');
          }

          // Extract Category
          final categoryElement = document.querySelectorAll('tr').firstWhereOrNull(
                (element) => element.querySelector('td')?.text.contains('Category') ?? false,
              );

          if (categoryElement != null) {
            categoryName = categoryElement.querySelectorAll('td')[1]?.text.trim() ?? '';
          } else {
            print('Category not found.');
          }
        } else {
          print('Request failed with status code: ${response.statusCode}');
        }

        // Navigate to ContributePage with prefilled values
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContributePage(
              prefilledBarcode: _scanResult,
              prefilledCompanyName: brandName.isNotEmpty ? brandName : null,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error scanning barcode: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Scan Barcode'),
          onPressed: _scanBarcode,
        ),
      ),
      backgroundColor: const Color.fromRGBO(255, 220, 80, 1),
      bottomNavigationBar: NavigationControl(),
    );
  }
}
