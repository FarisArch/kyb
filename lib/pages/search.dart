import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kyb/navigation/navigation_bar.dart';
import 'package:kyb/pages/result_true.dart'; // Import ResultTruePage
import 'package:kyb/pages/result_false.dart'; // Import ResultFalsePage

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  List<String> _suggestions = [];
  List<String> _brandsInCategory = []; // List of brands in the selected category
  String _selectedCategory = ''; // Current selected category
  final CollectionReference barcodesCollection = FirebaseFirestore.instance.collection('barcodes');

  // Fetch search suggestions
  void _searchDatabase(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final normalizedQuery = query.toLowerCase();
      final QuerySnapshot result = await barcodesCollection.where('companyName', isGreaterThanOrEqualTo: normalizedQuery).where('companyName', isLessThanOrEqualTo: '$normalizedQuery\uf8ff').limit(5).get();

      setState(() {
        _suggestions = result.docs.map((doc) => (doc.data() as Map<String, dynamic>)['companyName'] as String).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Fetch brands for the selected category
  void _checkCategory(String category) async {
    setState(() {
      _isLoading = true;
      _selectedCategory = category; // Track selected category
      _brandsInCategory = []; // Reset the brand list
    });

    try {
      final QuerySnapshot result = await barcodesCollection
          .where('category', isEqualTo: category)
          .where('approved', isEqualTo: true) // Fetch only approved brands
          .get();

      setState(() {
        _brandsInCategory = result.docs.map((doc) => (doc.data() as Map<String, dynamic>)['companyName'] as String).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Redirect to brand details
  void _redirectToDetails(String selectedCompany) async {
    try {
      final result = await barcodesCollection.where('companyName', isEqualTo: selectedCompany).get();

      if (result.docs.isNotEmpty) {
        final product = result.docs.first.data() as Map<String, dynamic>;
        final brandType = product['brandType'];
        final approved = product['approved'];
        final companyName = product['companyName'];
        final category = product['category'];
        final link = product['link'];

        if (approved == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => brandType == "Non-Recommended Brand" ? ResultTruePage(companyName: companyName, brandType: brandType, category: category, link: link) : ResultFalsePage(companyName: companyName, brandType: brandType, category: category, link: link),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No results found.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationControl(),
      backgroundColor: const Color.fromRGBO(255, 220, 80, 1),
      appBar: AppBar(
        title: const Text("Search & Category"),
        backgroundColor: const Color.fromRGBO(255, 220, 80, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search a Brand',
                labelStyle: const TextStyle(color: Colors.black26),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: _searchDatabase,
            ),
            const SizedBox(height: 16),

            // Display Search Suggestions
            if (_suggestions.isNotEmpty)
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_suggestions[index], style: const TextStyle(color: Colors.black)),
                        onTap: () {
                          _searchController.text = _suggestions[index];
                          _redirectToDetails(_suggestions[index]);
                        },
                      );
                    },
                  ),
                ),
              ),

            // Categories Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: [
                  _buildCategoryTile(context, "Automotive", Icons.directions_car),
                  _buildCategoryTile(context, "Technology", Icons.devices),
                  _buildCategoryTile(context, "Fashion", Icons.checkroom),
                  _buildCategoryTile(context, "Manufacturer", Icons.factory),
                  _buildCategoryTile(context, "Supermarket", Icons.store),
                  _buildCategoryTile(context, "Cosmetics", Icons.brush),
                  _buildCategoryTile(context, "Finance", Icons.account_balance),
                  _buildCategoryTile(context, "F&B", Icons.fastfood),
                  _buildCategoryTile(context, "Entertainment", Icons.movie),
                ],
              ),
            ),

            // Display Brands in Selected Category
            if (_selectedCategory.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                'Brands in $_selectedCategory',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _isLoading
                  ? const CircularProgressIndicator()
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _brandsInCategory.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              _brandsInCategory[index],
                              style: const TextStyle(color: Colors.white),
                            ),
                            onTap: () => _redirectToDetails(_brandsInCategory[index]),
                          );
                        },
                      ),
                    ),
            ],
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
            BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 2, blurRadius: 5)
          ],
        ),
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Colors.black),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
