import 'package:flutter/material.dart';
import 'package:kyb/navigation/navigation_bar.dart';
import 'package:kyb/models/article.dart'; // Import the Article model
import 'package:kyb/pages/pages.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<Article> _articles = []; // List to hold the articles
  bool _isLoading = true; // Flag to track loading state
  int _page = 1; // Page number for pagination
  bool _isFetchingMore = false; // Flag to track additional data fetching
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadArticles(); // Load initial articles

    // Add scroll listener for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isFetchingMore) {
        _loadMoreArticles();
      }
    });
  }

  _loadArticles() async {
    try {
      final articles = await Article.fetchArticles(page: _page); // Fetch articles with pagination
      setState(() {
        _articles.addAll(articles);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load articles: $e')),
      );
    }
  }

  _loadMoreArticles() async {
    setState(() {
      _isFetchingMore = true;
    });

    try {
      _page++;
      final articles = await Article.fetchArticles(page: _page);
      setState(() {
        _articles.addAll(articles);
        _isFetchingMore = false;
      });
    } catch (e) {
      setState(() {
        _isFetchingMore = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load more articles: $e')),
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
            SizedBox(height: 20),

            // Using ListView.builder to display a list of NewsCard widgets
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator()) // Display a loading indicator while data is being loaded
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _articles.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _articles.length) {
                          return _isFetchingMore ? Center(child: CircularProgressIndicator()) : SizedBox.shrink();
                        }

                        final article = _articles[index]; // Access the corresponding article in the list
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: NewsCard(
                            article: article,
                            backgroundColor: Colors.white,
                          ),
                        ); // Pass the article data to the NewsCard widget
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
