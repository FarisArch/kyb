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
      final QuerySnapshot result = await barcodesCollection.where('companyName', isGreaterThanOrEqualTo: query).where('companyName', isLessThanOrEqualTo: query + '\uf8ff').limit(5).get();

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
        final product = result.docs.first.data() as Map<String, dynamic>;
        final brandType = product['brandType'];
        final approved = product['approved'];
        final companyName = product['companyName'];
        final category = product['category'];
        final link = product['link'];

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
            const SnackBar(content: Text('No action required (unapproved or null).')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No results found for selected company.')),
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
        title: const Text("Search & Category"),
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
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: [
                  _buildCategoryTile(context, "Automotive", Icons.directions_car),
                  _buildCategoryTile(context, "Technology", Icons.devices),
                  _buildCategoryTile(context, "Fashion", Icons.checkroom),
                  _buildCategoryTile(context, "Manufact", Icons.factory),
                  _buildCategoryTile(context, "Store", Icons.store),
                  _buildCategoryTile(context, "Cosmetics", Icons.brush),
                  _buildCategoryTile(context, "Finance", Icons.account_balance),
                  _buildCategoryTile(context, "F&B", Icons.fastfood),
                  _buildCategoryTile(context, "Entertain", Icons.movie),
                ],
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
