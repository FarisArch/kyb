import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore

class ReportWrongClass extends StatefulWidget {
  final String companyName; // Accept companyName from the result page

  ReportWrongClass({required this.companyName});

  @override
  _ReportWrongClassState createState() => _ReportWrongClassState();
}

class _ReportWrongClassState extends State<ReportWrongClass> {
  String? selectedCategory;
  final TextEditingController linkController = TextEditingController();

  // Define the list of ethical classifications
  final List<String> categories = [
    'Product should be unsafe & unethical',
    'Product should be safe and ethical',
  ];

  // Submit the form and save data to Firebase
  Future<void> _submitForm() async {
    if (selectedCategory != null && linkController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('report_list').add({
          'companyName': widget.companyName, // Save the company name
          'brandType': selectedCategory, // Save the selected ethical classification
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
        SnackBar(content: Text('Please select an option and provide a link.')),
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
            // Dropdown for Ethical Classification selection
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'ETHICAL CLASSIFICATION',
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
                labelText: 'LINK OF EVIDENCES',
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
