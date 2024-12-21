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
  List<String> _brandsInCategory = [];
  String _selectedCategory = '';
  final CollectionReference barcodesCollection = FirebaseFirestore.instance.collection('barcodes');
  List<String> _allBrandsInCategory = []; // Backup of all brands in the selected category

  String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ') // Split the text by spaces
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()) // Capitalize each word
        .join(' '); // Join them back with spaces
  }

  // Fetch search suggestions
  void _searchDatabase(String query) async {
    if (query.isEmpty) {
      setState(() {
        // Restore the full list if the search query is empty
        _brandsInCategory = List.from(_allBrandsInCategory);
        _suggestions = [];
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final normalizedQuery = query.toLowerCase();

      if (_selectedCategory.isEmpty) {
        // Default behavior: search database
        final QuerySnapshot result = await barcodesCollection.where('companyName', isGreaterThanOrEqualTo: normalizedQuery).where('companyName', isLessThanOrEqualTo: '$normalizedQuery\uf8ff').limit(5).get();

        setState(() {
          _suggestions = result.docs.map((doc) => (doc.data() as Map<String, dynamic>)['companyName'] as String).toList();
        });
      } else {
        // Filter the _brandsInCategory list when a category is selected
        setState(() {
          _brandsInCategory = _allBrandsInCategory.where((brand) => brand.toLowerCase().contains(normalizedQuery)).toList();
        });
      }
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
      _selectedCategory = category;
      _brandsInCategory = [];
      _allBrandsInCategory = []; // Clear backup list
      _searchController.clear(); // Clear search bar
    });

    try {
      final QuerySnapshot result = await barcodesCollection.where('category', isEqualTo: category).where('approved', isEqualTo: true).get();

      setState(() {
        _brandsInCategory = result.docs.map((doc) => (doc.data() as Map<String, dynamic>)['companyName'] as String).toList();
        _allBrandsInCategory = List.from(_brandsInCategory); // Save a copy of the original list
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

        // Safely extract data with default values
        final brandType = product['brandType'] ?? 'Unknown';
        final approved = product['approved'] ?? false; // Default to false
        final companyName = product['companyName'] ?? 'Unknown';
        final category = product['category'] ?? 'Uncategorized';
        final link = product['evidenceLink'] ?? ''; // FIXED: Use evidenceLink field

        if (approved == true) {
          if (brandType == "Non-Recommended Brand") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultTruePage(
                  companyName: companyName,
                  brandType: brandType,
                  category: category,
                  link: link,
                ),
              ),
            );
          } else if (brandType == "Recommended Brand") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultFalsePage(
                  companyName: companyName,
                  brandType: brandType,
                  category: category,
                  link: link,
                ),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Brand is not approved.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No results found.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
        leading: _selectedCategory.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  setState(() {
                    _selectedCategory = ''; // Reset the selected category
                    _brandsInCategory = []; // Clear the brands list
                  });
                },
              )
            : null, // Show back button only when a category is selected
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                Container(
                  color: Colors.white,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          toTitleCase(_suggestions[index]),
                          style: const TextStyle(color: Colors.black),
                        ),
                        onTap: () {
                          _searchController.text = _suggestions[index];
                          _redirectToDetails(_suggestions[index]);
                        },
                      );
                    },
                  ),
                ),

              // Show either the grid or the brands list based on the selected category
              if (_selectedCategory.isEmpty)
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                )
              else ...[
                const SizedBox(height: 10),
                Text(
                  'Brands in $_selectedCategory',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _brandsInCategory.length,
                        itemBuilder: (context, index) {
                          return Container(
                            color: Colors.white, // Set background color to white
                            child: ListTile(
                              title: Text(
                                toTitleCase(_brandsInCategory[index]), // Convert to title case for better readability
                                style: const TextStyle(color: Colors.black), // Text color
                              ),
                              onTap: () => _redirectToDetails(_brandsInCategory[index]),
                            ),
                          );
                        },
                      )
              ],
            ],
          ),
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
            BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 2, blurRadius: 5),
          ],
        ),
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8), // Reduced padding for more space
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Colors.black),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                maxLines: 2, // Allow text to wrap to a second line if needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
