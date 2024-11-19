import 'package:flutter/material.dart';
import 'package:kyb/models/article.dart';

class NewsCard extends StatelessWidget {
  final Article article;
  final Color backgroundColor;

  NewsCard({required this.article, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      width: 320,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            article.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4.0),

          // Subtitle
          Text(
            article.description,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            article.publishedAt,
            style: TextStyle(
              fontSize: 10,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.0),

          // Image section
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Image.network(
                article.urlToImage,
                height: 150, // Set the height of the image to 150
                width: 250, // Set the width of the image to 250
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
