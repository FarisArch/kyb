import 'package:flutter/material.dart';

class ReportWrongClass extends StatefulWidget {
  @override
  _ReportWrongClassState createState() => _ReportWrongClassState();
}

class _ReportWrongClassState extends State<ReportWrongClass> {
  String? selectedCategory;
  final TextEditingController linkController = TextEditingController();

  // Define the list of categories
  final List<String> categories = [
    'Product should be unsafe & unethical',
    'Product should be safe and ethical',
  ];

  void _submitForm() {
    // Check if category and link are not empty
    if (selectedCategory != null && linkController.text.isNotEmpty) {
      Navigator.pushNamed(context, '/successful_report');
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
            // Dropdown for Category selection
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
