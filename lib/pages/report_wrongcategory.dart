import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore

class ReportWrongCategory extends StatefulWidget {
  final String companyName;

  ReportWrongCategory({required this.companyName});

  @override
  _ReportWrongCategoryState createState() => _ReportWrongCategoryState();
}

class _ReportWrongCategoryState extends State<ReportWrongCategory> {
  String? selectedBarcode;
  String? selectedCategory;
  final TextEditingController linkController = TextEditingController();

  // Define the list of categories
  final List<String> categories = [
    'Technology',
    'Fashion',
    'Household',
    'Cosmetics',
    'Food',
    'Healthcare',
  ];

  // Fetch the barcode entries for the company
  Future<List<String>> _fetchBarcodes() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('barcodes').where('companyName', isEqualTo: widget.companyName).get();

      return snapshot.docs.map((doc) => doc['barcodeNum'] as String).toList();
    } catch (error) {
      // Handle the error and return an empty list if fetching fails
      print('Error fetching barcodes: $error');
      return [];
    }
  }

  // Submit the form and save data to Firebase
  Future<void> _submitForm() async {
    if (selectedBarcode != null && selectedCategory != null && linkController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('report_list').add({
          'companyName': widget.companyName,
          'barcodeNum': selectedBarcode, // Add the barcodeNum field
          'category': selectedCategory,
          'link': linkController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        Navigator.pushNamed(context, '/successfulReport');
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting report: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a barcode, category, and provide a link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 220, 80, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'Help us to put this product in the correct category',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            // Dropdown for Barcode selection
            FutureBuilder<List<String>>(
              future: _fetchBarcodes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error fetching barcodes');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No barcodes available for this company');
                }

                final barcodes = snapshot.data!;

                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Barcode',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.qr_code), // Corrected here
                  ),
                  value: selectedBarcode,
                  items: barcodes.map((barcode) {
                    return DropdownMenuItem(
                      value: barcode,
                      child: Text(barcode),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBarcode = value;
                    });
                  },
                );
              },
            ),
            SizedBox(height: 20),
            // Dropdown for Category selection
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.shopping_cart),
              ),
              value: selectedCategory,
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
            SizedBox(height: 20),
            // Text field for Link of Evidence
            TextFormField(
              controller: linkController,
              decoration: InputDecoration(
                labelText: 'Link of Evidence',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
            ),
            SizedBox(height: 30),
            // Submit button
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('SUBMIT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
