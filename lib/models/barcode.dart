import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Barcode {
  String barcodeNum;
  String companyName;
  String category;

  Barcode({
    required this.barcodeNum,
    required this.companyName,
    required this.category,
  });

  Barcode.fromJson(Map<String, Object?> json)
      : this(
          barcodeNum: json['barcodeNum']! as String,
          companyName: json['companyName']! as String,
          category: json['category']! as String,
        );

  Barcode copyWith({
    String? barcodeNum,
    String? companyName,
    String? category,
  }) {
    return Barcode(barcodeNum: barcodeNum ?? this.barcodeNum, companyName: companyName ?? this.companyName, category: category ?? this.category);
  }

  Map<String, Object?> toJson() {
    return {
      'barcodeNum': barcodeNum,
      'companyName': companyName,
      'category': category,
    };
  }
}
