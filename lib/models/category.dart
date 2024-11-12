import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Category {
  String categoryID;
  String categoryName;

  Category({
    required this.categoryID,
    required this.categoryName,
  });

  Category.fromJson(Map<String, Object?> json)
      : this(
          categoryID: json['categoryID']! as String,
          categoryName: json['categroyName']! as String,
        );

  Category copyWith({
    String? categoryID,
    String? categoryName,
  }) {
    return Category(categoryID: categoryID ?? this.categoryID, categoryName: categoryName ?? this.categoryName);
  }

  Map<String, Object?> toJson() {
    return {
      'categoryID': categoryID,
      'categoryName': categoryName,
    };
  }
}
