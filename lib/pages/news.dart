import 'package:flutter/material.dart';
import 'package:kyb/navigation/navigation_bar.dart';
import 'package:kyb/pages/pages.dart';
import 'package:kyb/models/article.dart'; // Import the Article model

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<Article> _articles = []; // List to hold the articles
  bool _isLoading = true; // Flag to track loading state
  String _selectedCategory = ''; // Store the selected category

  @override
  void initState() {
    super.initState();
    _loadArticles(); // Load articles when the widget is initialized
  }

  _loadArticles([String? category]) async {
    try {
      final articles = await Article.fetchArticles(category ?? ''); // Fetch articles from the API
      setState(() {
        _articles = articles; // Update the list of articles
        _isLoading = false; // Set the loading flag to false
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Set the loading flag to false
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load articles: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationControl(),
      backgroundColor: Color.fromRGBO(255, 220, 80, 1),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryButton('All'),
                  _buildCategoryButton('Food & Beverage'),
                  _buildCategoryButton('Fashion'),
                  _buildCategoryButton('Cosmetics'),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Using ListView.builder to display a list of NewsCard widgets
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator()) // Display a loading indicator while data is being loaded
                  : ListView.builder(
                      itemCount: _articles.length, // Build one item for each article
                      itemBuilder: (context, index) {
                        final article = _articles[index]; // Access the corresponding article in the list
                        return NewsCard(article: article); // Pass the article data to the NewsCard widget
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String title) {
    return GestureDetector(
      onTap: () {
        print('$title button was clicked');
        setState(() {
          _selectedCategory = title; // Update the selected category
          _loadArticles(_selectedCategory); // Call the _loadArticles method with the category as a parameter
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          title,
          style: TextStyle(
            color: Color.fromRGBO(255, 220, 80, 1),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
