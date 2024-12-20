import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditBrandPage extends StatefulWidget {
  final String documentId;
  final String companyName;
  final String brandType;
  final String category;
  final String link;
  final bool? approved;
  final String? logoUrl; // Added logoUrl field

  const EditBrandPage({
    super.key,
    required this.documentId,
    required this.companyName,
    required this.brandType,
    required this.category,
    required this.link,
    required this.approved,
    this.logoUrl, // Optional logoUrl field
  });

  @override
  _EditBrandPageState createState() => _EditBrandPageState();
}

class _EditBrandPageState extends State<EditBrandPage> {
  late TextEditingController _companyNameController;
  late TextEditingController _linkController;
  late TextEditingController _logoUrlController; // Added TextEditingController for logoUrl
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
    _linkController = TextEditingController(text: widget.link);
    _logoUrlController = TextEditingController(text: widget.logoUrl ?? ''); // Initialize with existing logoUrl or empty string
    _approved = widget.approved;

    // Validate category and brand type against available options
    _selectedCategory = _categories.contains(widget.category) ? widget.category : _categories.first;
    _selectedBrandType = _brandTypes.contains(widget.brandType) ? widget.brandType : _brandTypes.first;
  }

  void _saveChanges() async {
    try {
      final docRef = FirebaseFirestore.instance.collection('barcodes').doc(widget.documentId);

      await docRef.update({
        'companyName': _companyNameController.text,
        'brandType': _selectedBrandType.toLowerCase(),
        'category': _selectedCategory.toLowerCase(),
        'link': _linkController.text,
        'approved': _approved,
        'logoUrl': _logoUrlController.text, // Save the logoUrl
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
                  labelStyle: const TextStyle(color: Colors.black26),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _brandTypes.map((brandType) {
                  return DropdownMenuItem(
                    value: brandType,
                    child: Text(
                      brandType,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBrandType = value ?? '';
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: const TextStyle(color: Colors.black26),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(
                      category,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value ?? '';
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _linkController,
                decoration: InputDecoration(
                  labelText: 'Evidence Link',
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
                controller: _logoUrlController, // Added TextField for logoUrl
                decoration: InputDecoration(
                  labelText: 'Logo URL (Optional)',
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
              SwitchListTile(
                title: const Text(
                  'Approved',
                  style: TextStyle(color: Colors.black),
                ),
                value: _approved ?? false,
                onChanged: (value) {
                  setState(() {
                    _approved = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(255, 193, 7, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _saveChanges,
                child: const Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
