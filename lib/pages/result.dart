import 'package:flutter/material.dart';
import 'result_false.dart';
import 'result_true.dart';

class ResultPage extends StatelessWidget {
  final bool isBoycotted; // Determines which page to show
  final String companyName;
  final String brandType;
  final String category;
  final String link;

  ResultPage({
    super.key,
    required this.isBoycotted,
    required this.companyName,
    required this.brandType,
    required this.category,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return isBoycotted
        ? ResultTruePage(
            companyName: companyName,
            brandType: brandType,
            category: category,
            link: link,
          )
        : ResultFalsePage(
            companyName: companyName,
            brandType: brandType,
            category: category,
            link: link,
          );
  }
}
