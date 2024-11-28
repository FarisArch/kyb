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

  static Future<List<Article>> fetchArticles(String category) async {
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));
    final formattedDate = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';

    final response = await http.get(Uri.parse('https://newsapi.org/v2/everything?q=$category&from=$formattedDate&sortBy=popularity&apiKey=$news_api_key&pageSize=2'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final articles = jsonData['articles'].map<Article>((article) => Article.fromJson(article)).toList();
      return articles;
    } else {
      throw Exception('Failed to load articles: ${response.statusCode}');
    }
  }
}
