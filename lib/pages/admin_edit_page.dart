import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditBrandPage extends StatefulWidget {
  final String documentId;
  final String companyName;
  final String brandType;
  final String category;
  final bool? approved;
  final String evidenceLink;
  final String logoURL;
  final String barcodeNum; // Added barcodeNum field

  const EditBrandPage({
    super.key,
    required this.documentId,
    required this.companyName,
    required this.brandType,
    required this.category,
    required this.approved,
    required this.evidenceLink,
    required this.logoURL,
    required this.barcodeNum, // Required barcodeNum
  });

  @override
  _EditBrandPageState createState() => _EditBrandPageState();
}

class _EditBrandPageState extends State<EditBrandPage> {
  late TextEditingController _companyNameController;
  late TextEditingController _evidenceLinkController; // Renamed controller
  late TextEditingController _logoURLController; // Updated name
  bool? _approved;
  late String _selectedCategory;
  late String _selectedBrandType;

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

  @override
  void initState() {
    super.initState();
    _companyNameController = TextEditingController(text: widget.companyName);
    _evidenceLinkController = TextEditingController(text: widget.evidenceLink); // Set evidence link
    _logoURLController = TextEditingController(text: widget.logoURL); // Set logo URL
    _approved = widget.approved ?? false;

    _selectedCategory = _categories.contains(widget.category) ? widget.category : _categories.first;
    _selectedBrandType = _brandTypes.contains(widget.brandType) ? widget.brandType : _brandTypes.first;
  }

  void _saveChanges() async {
    try {
      final docRef = FirebaseFirestore.instance.collection('barcodes').doc(widget.documentId);

      await docRef.update({
        'companyName': _companyNameController.text,
        'brandType': _selectedBrandType.toLowerCase(), // Enforce lowercase
        'category': _selectedCategory.toLowerCase(), // Enforce lowercase
        'approved': _approved,
        'evidenceLink': _evidenceLinkController.text, // Correct field name
        'logoURL': _logoURLController.text, // Correct field name
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved successfully!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving changes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Brand Details'),
        backgroundColor: const Color.fromRGBO(255, 220, 80, 1),
      ),
      backgroundColor: const Color.fromRGBO(255, 220, 80, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Display barcode number (read-only)
              TextField(
                controller: TextEditingController(text: widget.barcodeNum),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Barcode Number',
                  labelStyle: const TextStyle(color: Colors.black26),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _companyNameController,
                decoration: InputDecoration(
                  labelText: 'Company Name',
                  labelStyle: const TextStyle(color: Colors.black26),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedBrandType,
                decoration: InputDecoration(
                  labelText: 'Brand Type',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _brandTypes.map((brandType) {
                  return DropdownMenuItem(
                    value: brandType,
                    child: Text(brandType),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  _selectedBrandType = value ?? '';
                }),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  _selectedCategory = value ?? '';
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _evidenceLinkController,
                decoration: InputDecoration(
                  labelText: 'Evidence Link',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _logoURLController,
                decoration: InputDecoration(
                  labelText: 'Logo URL',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Approved'),
                value: _approved ?? false,
                onChanged: (value) => setState(() {
                  _approved = value;
                }),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
