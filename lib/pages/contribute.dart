import 'package:flutter/material.dart';
import 'package:kyb/models/contribute_barcode.dart';
import 'package:kyb/services/database_service_barcode.dart'; // Use the barcode service for saving to the 'barcodes' collection

class ContributePage extends StatefulWidget {
  @override
  _ContributePageState createState() => _ContributePageState();
}

class _ContributePageState extends State<ContributePage> {
  final _brandNameController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _evidenceLinkController = TextEditingController();

  String? _selectedCategory;
  String? _selectedBrandType;

  final List<String> _categories = [
    'Automotive',
    'Fashion',
    'Technology',
    'Manufacturer',
    'Supermarket',
    'Cosmetics',
    'Finance',
    'F&B',
    'Entertainment',
  ];

  final List<String> _brandTypes = [
    'Recommended Brand',
    'Non-Recommended Brand',
  ];

  final DatabaseServiceBarcode _databaseService = DatabaseServiceBarcode();

  void _submitContributeBarcode() async {
    final brandName = _brandNameController.text.trim();
    final barcode = _barcodeController.text.trim();
    final evidenceLink = _evidenceLinkController.text.trim();

    if (brandName.isEmpty || barcode.isEmpty || evidenceLink.isEmpty || _selectedCategory == null || _selectedBrandType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    final contributeBarcode = ContributeBarcode(
      barcodeNum: barcode,
      companyName: brandName,
      category: _selectedCategory!,
      brandType: _selectedBrandType!,
      link: evidenceLink, approved: false,
    );

    // Check if the barcode already exists
    bool barcodeExists = await _databaseService.checkBarcodeExists(barcode);

    if (barcodeExists) {
      // If barcode exists, show snackbar and navigate to /home
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product already exists!')),
      );
      Navigator.pushNamed(context, '/home'); // Redirect to /home
    } else {
      // If barcode doesn't exist, save the barcode in the 'barcodes' collection
      await _databaseService.addBarcode(contributeBarcode);

      // Show success message and navigate to successful contribution page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contribution submitted successfully')),
      );
      Navigator.pushNamed(context, '/successfulContribute');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFD44F), // Background color as per the image
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Know a brand?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Suggest an alternative brand or a non-recommended brand!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // Brand Name Field
              TextField(
                controller: _brandNameController,
                decoration: InputDecoration(
                  labelText: 'Brand Name',
                  labelStyle: TextStyle(color: Colors.black38),
                  hintText: 'Type here',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(color: Colors.black38),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Brand Type Dropdown (Unethical/Alternative)
              DropdownButtonFormField<String>(
                value: _selectedBrandType,
                items: _brandTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBrandType = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Brand Type',
                  labelStyle: TextStyle(color: Colors.black38),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Barcode/Serial Number Field
              TextField(
                controller: _barcodeController,
                decoration: InputDecoration(
                  labelText: 'Barcode / Serial Number',
                  labelStyle: TextStyle(color: Colors.black38),
                  hintText: 'Type here',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Link of Evidence Field
              TextField(
                controller: _evidenceLinkController,
                decoration: InputDecoration(
                  labelText: 'Link of Evidences',
                  labelStyle: TextStyle(color: Colors.black38),
                  hintText: 'Type here',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Submit Button
              ElevatedButton(
                onPressed: _submitContributeBarcode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'SUBMIT',
                      style: TextStyle(color: Colors.black),
                    ),
                    Icon(Icons.arrow_forward, color: Colors.black),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
