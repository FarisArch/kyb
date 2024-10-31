import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
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
            "Israel’s raids on Jenin only fuel Palestinian resistance",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.0),

          // Subtitle
          Text(
            "Aljazeera News",
            style: TextStyle(
              color: Color.fromRGBO(255, 220, 80, 1),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "2 June 2024",
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
                  child: Image.asset(
                    'assets/1.jpg', // Replace with your image URL
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
