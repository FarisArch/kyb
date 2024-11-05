// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kyb/pages/pages.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom; // Alias the html package's `Element`
import 'package:kyb/navigation/navigation_bar.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String _scanResult = '';
  int _currentIndex = 2;

  final pages = [
    Home(),
    NewsPage(),
    ScanPage(),
    // SearchPage(),
    // ContributePage(),
  ];

  Future<void> _scanBarcode() async {
    try {
      final ScanResult barcodeScanRes = await BarcodeScanner.scan();
      setState(() {
        _scanResult = barcodeScanRes.rawContent;
      });

      final url = 'https://go-upc.com/search?q=${_scanResult}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final document = parse(response.body);

        // Extract Brand
        final dom.Element? brandElement = document.querySelectorAll('tr').firstWhere(
              (element) => element.querySelector('td')?.text.contains('Brand') ?? false,
              orElse: () => dom.Element.tag('dummy'), // Return a dummy element if not found
            );

        // Extract Category
        final dom.Element? categoryElement = document.querySelectorAll('tr').firstWhere(
              (element) => element.querySelector('td')?.text.contains('Category') ?? false,
              orElse: () => dom.Element.tag('dummy'), // Return a dummy element if not found
            );

        // Check and retrieve Brand name
        if (brandElement != null && brandElement.querySelectorAll('td').length > 1) {
          final brandName = brandElement.querySelectorAll('td')[1]?.text.trim() ?? 'N/A'; // Get the value in the next <td>
          print('Brand: $brandName');
        } else {
          print('Brand not found');
        }

        // Check and retrieve Category name
        if (categoryElement != null && categoryElement.querySelectorAll('td').length > 1) {
          final categoryName = categoryElement.querySelectorAll('td')[1]?.text.trim() ?? 'N/A'; // Get the value in the next <td>
          print('Category: $categoryName');
        } else {
          print('Category not found');
        }
      } else {
        print('Request failed with status code: ${response.statusCode}');
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
