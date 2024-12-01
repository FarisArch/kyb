import 'package:flutter/material.dart';
import 'package:kyb/models/contribute_barcode.dart';
import 'package:kyb/services/database_service_barcode.dart';

class AdminContributePage extends StatefulWidget {
  @override
  _AdminContributePageState createState() => _AdminContributePageState();
}

class _AdminContributePageState extends State<AdminContributePage> {
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

  void _submitAdminContribution() async {
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
      link: evidenceLink, approved: true,
    );

    // Directly add the barcode to the database
    await _databaseService.addBarcode(contributeBarcode);

    // Show success message and navigate back to the admin dashboard
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Brand added successfully')),
    );
    Navigator.pushNamed(context, '/adminDashboard'); // Redirect to admin dashboard
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFD44F),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Admin Contribution',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Add a brand directly to the database.',
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

              // Brand Type Dropdown
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
                  labelText: 'Link of Evidence',
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
                onPressed: _submitAdminContribution,
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
                      'ADD BRAND',
                      style: TextStyle(color: Colors.black),
                    ),
                    Icon(Icons.check, color: Colors.black),
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
