import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kyb/navigation/navigation_bar.dart';
import 'package:kyb/pages/result_true.dart'; // Import ResultTruePage
import 'package:kyb/pages/result_false.dart'; // Import ResultFalsePage
import 'package:kyb/pages/admin_edit_page.dart';

class AdminBrandsUpdate extends StatefulWidget {
  const AdminBrandsUpdate({super.key});

  @override
  _AdminBrandsUpdateState createState() => _AdminBrandsUpdateState();
}

class _AdminBrandsUpdateState extends State<AdminBrandsUpdate> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  List<String> _suggestions = [];
  final CollectionReference barcodesCollection = FirebaseFirestore.instance.collection('barcodes');

  void _searchDatabase(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final normalizedQuery = query.toLowerCase(); // Convert query to lowercase

      final QuerySnapshot result = await barcodesCollection.where('companyName', isGreaterThanOrEqualTo: normalizedQuery).where('companyName', isLessThanOrEqualTo: '$normalizedQuery\uf8ff').limit(5).get();

      // Use a Set to ensure no duplicate company names
      Set<String> uniqueCompanies = {};
      result.docs.forEach((doc) {
        uniqueCompanies.add((doc.data() as Map<String, dynamic>)['companyName'] as String);
      });

      setState(() {
        _suggestions = uniqueCompanies.toList(); // Convert Set back to List for display
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching database: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _checkCategory(String category) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final QuerySnapshot result = await barcodesCollection.where('category', isEqualTo: category).get();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.docs.isNotEmpty ? 'Found brands in $category category.' : 'No brands found in $category category.',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking category: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateAllEntries(String selectedCompany, Map<String, dynamic> updatedData) async {
    try {
      final QuerySnapshot result = await barcodesCollection.where('companyName', isEqualTo: selectedCompany).get();

      // Batch update all matching documents
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var doc in result.docs) {
        batch.update(doc.reference, updatedData);
      }

      await batch.commit();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All entries updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating entries: $e')),
      );
    }
  }

  void _redirectToDetails(String selectedCompany) async {
    try {
      final QuerySnapshot result = await barcodesCollection.where('companyName', isEqualTo: selectedCompany).get();

      if (result.docs.isNotEmpty) {
        // Safely loop through documents and check for valid data
        final doc = result.docs.first; // Use the first match for editing
        final data = doc.data();

        // Ensure data is not null and is a Map
        if (data != null && data is Map<String, dynamic>) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditBrandPage(
                documentId: doc.id,
                companyName: data['companyName'] ?? '',
                brandType: data['brandType'] ?? '',
                category: data['category'] ?? '',
                approved: data['approved'] ?? false, // Default to false
                evidenceLink: data['evidenceLink'] ?? '',
                logoURL: data['logoURL'] ?? '',
                barcodeNum: data['barcodeNum'] ?? '',
              ),
            ),
          ).then((updatedData) {
            // After editing, apply changes to all matching documents
            if (updatedData != null) {
              _updateAllEntries(selectedCompany, updatedData);
            }
          });
        } else {
          // Handle invalid data scenario
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid data format for the selected company.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No results found for the selected company.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error redirecting: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 220, 80, 1),
      appBar: AppBar(
        title: const Text("Search for brands to update"),
        backgroundColor: const Color.fromRGBO(255, 220, 80, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search a Brand',
                labelStyle: const TextStyle(color: Colors.black26),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: _searchDatabase, // Only search for suggestions, no redirection
            ),
            const SizedBox(height: 16),
            if (_suggestions.isNotEmpty)
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          title: Text(
                            _suggestions[index],
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onTap: () {
                            _searchController.text = _suggestions[index];
                            _redirectToDetails(_suggestions[index]);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
