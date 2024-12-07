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

      setState(() {
        _suggestions = result.docs.map((doc) => (doc.data() as Map<String, dynamic>)['companyName'] as String).toList();
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

  void _redirectToDetails(String selectedCompany) async {
    try {
      final result = await barcodesCollection.where('companyName', isEqualTo: selectedCompany).get();

      if (result.docs.isNotEmpty) {
        final doc = result.docs.first;
        final product = doc.data() as Map<String, dynamic>;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditBrandPage(
              documentId: doc.id,
              companyName: product['companyName'],
              brandType: product['brandType'],
              category: product['category'],
              link: product['link'],
              approved: product['approved'],
            ),
          ),
        );
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
      bottomNavigationBar: NavigationControl(),
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
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTile(BuildContext context, String label, IconData icon) {
    return GestureDetector(
      onTap: () => _checkCategory(label),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Colors.black),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
