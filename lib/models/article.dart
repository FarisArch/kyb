import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kyb/services/api_key.dart';
import 'dart:core';

class Article {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;

  Article({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
    };
  }

  static Future<List<Article>> fetchArticles({int page = 1}) async {
    final now = DateTime.now();
    final formattedDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    // API call to fetch articles related to "boycott" from today's date
    final response = await http.get(Uri.parse('https://newsapi.org/v2/top-headlines?sources=al-jazeera-english&from=$formattedDate&sortBy=popularity&apiKey=$news_api_key&pageSize=10&page=$page'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final articles = jsonData['articles'].map<Article>((article) => Article.fromJson(article)).toList();
      return articles;
    } else {
      throw Exception('Failed to load articles: ${response.statusCode}');
    }
  }
}
