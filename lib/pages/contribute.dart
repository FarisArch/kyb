import 'package:flutter/material.dart';
import 'package:kyb/models/barcode.dart';
import 'package:kyb/services/database_service_barcode.dart';

class ContributePage extends StatefulWidget {
  final String? prefilledBarcode;
  final String? prefilledCompanyName;

  const ContributePage({
    Key? key,
    this.prefilledBarcode,
    this.prefilledCompanyName,
  }) : super(key: key);

  @override
  _ContributePageState createState() => _ContributePageState();
}

class _ContributePageState extends State<ContributePage> {
  late TextEditingController _brandNameController;
  late TextEditingController _barcodeController;
  final _evidenceLinkController = TextEditingController();

  String? _selectedCategory;
  String? _selectedBrandType;

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

  final DatabaseServiceBarcode _databaseService = DatabaseServiceBarcode();

  @override
  void initState() {
    super.initState();
    _brandNameController = TextEditingController(text: widget.prefilledCompanyName ?? '');
    _barcodeController = TextEditingController(text: widget.prefilledBarcode ?? '');
  }

  @override
  void dispose() {
    _brandNameController.dispose();
    _barcodeController.dispose();
    _evidenceLinkController.dispose();
    super.dispose();
  }

  bool _isValidUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

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

    if (!_isValidUrl(evidenceLink)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide a valid URL for evidence link')),
      );
      return;
    }

    try {
      final newBarcode = Barcode(
        barcodeNum: barcode,
        companyName: brandName,
        category: _selectedCategory!.toLowerCase(), // Convert category to lowercase
        brandType: _selectedBrandType,
        evidenceLink: evidenceLink,
        approved: false,
      );

      bool barcodeExists = await _databaseService.checkBarcodeExists(barcode);

      if (barcodeExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product already exists!')),
        );
        return;
      }

      await _databaseService.addBarcode(newBarcode);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contribution submitted successfully')),
      );
      Navigator.pushNamed(context, '/successfulContribute');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  InputDecoration _inputDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.black38),
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFD44F),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
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
                TextField(
                  controller: _brandNameController,
                  decoration: _inputDecoration('Brand Name', hint: 'Type here'),
                ),
                SizedBox(height: 15),
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
                  decoration: _inputDecoration('Category'),
                ),
                SizedBox(height: 15),
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
                  decoration: _inputDecoration('Brand Type'),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _barcodeController,
                  decoration: _inputDecoration('Barcode / Serial Number', hint: 'Type here'),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _evidenceLinkController,
                  decoration: _inputDecoration('Link of Evidences', hint: 'Type here'),
                ),
                SizedBox(height: 30),
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
      ),
    );
  }
}
