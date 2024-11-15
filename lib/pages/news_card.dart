import 'package:flutter/material.dart';
import 'package:kyb/models/article.dart';

class NewsCard extends StatelessWidget {
  final Article article;

  NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 320,
      color: Colors.white,
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            article.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.0),

          // Subtitle
          Text(
            article.description,
            style: TextStyle(
              color: Color.fromRGBO(255, 220, 80, 1),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            article.publishedAt,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8.0),

          // Image section
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Image.network(
                    article.urlToImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
