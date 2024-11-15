import 'package:flutter/material.dart';
import 'result_false.dart';
import 'result_true.dart';

class ResultPage extends StatelessWidget {
  final bool isBoycotted; // This boolean determines which page to show

  ResultPage({required this.isBoycotted});

  @override
  Widget build(BuildContext context) {
    return isBoycotted ? ResultTruePage() : ResultFalsePage();
  }
}
