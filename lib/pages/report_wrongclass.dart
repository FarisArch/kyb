import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore

class ReportWrongClass extends StatefulWidget {
  final String companyName; // Accept companyName from the result page

  ReportWrongClass({required this.companyName});

  @override
  _ReportWrongClassState createState() => _ReportWrongClassState();
}

class _ReportWrongClassState extends State<ReportWrongClass> {
  String? selectedBarcode;
  String? recommendation;
  String? selectedCategory;
  final TextEditingController linkController = TextEditingController();

  // Define recommendation options
  final List<String> recommendations = [
    'Recommended Brand',
    'Non-Recommended Brand',
  ];

  // Define category options
  final List<String> categories = [
    'Technology',
    'Fashion',
    'Household',
    'Cosmetics',
    'Food',
    'Healthcare',
  ];

  // Fetch the barcodes for the selected company
  Future<List<String>> _fetchBarcodes() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('barcodes').where('companyName', isEqualTo: widget.companyName).get();

      final barcodes = snapshot.docs.map((doc) => doc['barcodeNum'] as String).toList();

      return barcodes;
    } catch (e) {
      debugPrint('Error fetching barcodes: $e');
      return [];
    }
  }

  // Submit the form and save data to Firebase
  Future<void> _submitForm() async {
    if (selectedBarcode != null && recommendation != null && selectedCategory != null && linkController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('report_list').add({
          'companyName': widget.companyName, // Save the company name
          'barcodeNum': selectedBarcode, // Save the selected barcode
          'brandType': recommendation, // Save the recommendation
          'category': selectedCategory, // Save the category
          'link': linkController.text, // Save the evidence link
          'timestamp': FieldValue.serverTimestamp(), // Save the submission time
        });

        // Navigate to a success page after successful submission
        Navigator.pushNamed(context, '/successfulReport');
      } catch (error) {
        // Show an error message if submission fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting report: $error')),
        );
      }
    } else {
      // Show an error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete all fields.')),
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
                    'Help us to classify the ethical classification correctly',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            // Fetch and display the barcode dropdown
            FutureBuilder<List<String>>(
              future: _fetchBarcodes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error loading barcodes');
                }

                final barcodes = snapshot.data ?? [];

                if (barcodes.isEmpty) {
                  return Text('No barcodes found for ${widget.companyName}');
                }

                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Barcode',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.qr_code),
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
            // Recommendation dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Recommendation',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.thumb_up),
              ),
              value: recommendation,
              items: recommendations.map((rec) {
                return DropdownMenuItem(
                  value: rec,
                  child: Text(rec),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  recommendation = value;
                });
              },
            ),
            SizedBox(height: 20),
            // Category dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              value: selectedCategory,
              items: categories.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
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
