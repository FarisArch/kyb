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
  final String barcodeNum;

  const EditBrandPage({
    super.key,
    required this.documentId,
    required this.companyName,
    required this.brandType,
    required this.category,
    required this.approved,
    required this.evidenceLink,
    required this.logoURL,
    required this.barcodeNum,
  });

  @override
  _EditBrandPageState createState() => _EditBrandPageState();
}

class _EditBrandPageState extends State<EditBrandPage> {
  late TextEditingController _companyNameController;
  late TextEditingController _evidenceLinkController;
  late TextEditingController _logoURLController;
  bool? _approved;
  late String _selectedCategory;
  late String _selectedBrandType;
  String? _selectedDocumentId;
  List<Map<String, dynamic>> _matchingEntries = [];

  final List<String> _categories = [
    'Technology',
    'Fashion',
    'Household',
    'Cosmetics',
    'Food',
    'Healthcare',
  ];

  final List<String> _brandTypes = [
    'Recommended Brand',
    'Non-Recommended Brand',
  ];

  @override
  void initState() {
    super.initState();

    // Initializing controllers with existing values
    _companyNameController = TextEditingController(text: widget.companyName);
    _evidenceLinkController = TextEditingController(text: widget.evidenceLink);
    _logoURLController = TextEditingController(text: widget.logoURL);
    _approved = widget.approved ?? false;

    // Ensure the selected category and brand type are set correctly
    _selectedCategory = _categories.contains(widget.category) ? widget.category : _categories.first;
    _selectedBrandType = _brandTypes.contains(widget.brandType) ? widget.brandType : _brandTypes.first;

    fetchMatchingEntries();
  }

  Future<void> fetchMatchingEntries() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('barcodes').where('companyName', isEqualTo: widget.companyName).get();

      setState(() {
        _matchingEntries = querySnapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
        _selectedDocumentId = widget.documentId;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching matching entries: $e')),
      );
    }
  }

  void _saveChanges() async {
    try {
      if (_selectedDocumentId == null) return;

      final docRef = FirebaseFirestore.instance.collection('barcodes').doc(_selectedDocumentId);

      // Only update fields if the user provides new values
      await docRef.update({
        'companyName': _companyNameController.text,
        'brandType': _selectedBrandType, // Ensure this is exactly the selected value
        'category': _selectedCategory.toLowerCase(),
        'approved': _approved,
        'evidenceLink': _evidenceLinkController.text.isNotEmpty ? _evidenceLinkController.text : widget.evidenceLink, // Don't overwrite if empty
        'logoURL': _logoURLController.text.isNotEmpty ? _logoURLController.text : widget.logoURL, // Don't overwrite if empty
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
              // Barcode dropdown
              DropdownButtonFormField<String>(
                value: _selectedDocumentId,
                decoration: InputDecoration(
                  labelText: 'Select Entry',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _matchingEntries.map<DropdownMenuItem<String>>((entry) {
                  return DropdownMenuItem<String>(
                    value: entry['id'],
                    child: Text(entry['barcodeNum'] ?? 'Unknown'),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  _selectedDocumentId = value;
                  final selectedEntry = _matchingEntries.firstWhere((entry) => entry['id'] == value);
                  _companyNameController.text = selectedEntry['companyName'] ?? '';
                }),
              ),
              const SizedBox(height: 16),
              // Company Name TextField
              TextField(
                controller: _companyNameController,
                decoration: InputDecoration(
                  labelText: 'Company Name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Brand Type dropdown
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
                items: _brandTypes.map<DropdownMenuItem<String>>((brandType) {
                  return DropdownMenuItem<String>(
                    value: brandType,
                    child: Text(brandType),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  _selectedBrandType = value ?? '';
                }),
              ),
              const SizedBox(height: 16),
              // Category dropdown
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
                items: _categories.map<DropdownMenuItem<String>>((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  _selectedCategory = value ?? '';
                }),
              ),
              const SizedBox(height: 16),
              // Evidence Link TextField
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
