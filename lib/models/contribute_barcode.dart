import 'package:kyb/models/barcode.dart';

class ContributeBarcode extends Barcode {
  final String brandType;
  final String link;
  final bool approved; // Add this field

  ContributeBarcode({
    required String barcodeNum,
    required String companyName,
    required String category,
    required this.brandType,
    required this.link,
    required this.approved, // Ensure it's initialized
  }) : super(
    barcodeNum: barcodeNum,
    companyName: companyName,
    category: category,
  );

  @override
  factory ContributeBarcode.fromJson(Map<String, Object?> json) {
    return ContributeBarcode(
      barcodeNum: json['barcodeNum']! as String,
      companyName: json['companyName']! as String,
      category: json['category']! as String,
      brandType: json['brandType']! as String,
      link: json['link']! as String,
      approved: json['approved'] as bool? ?? false, // Default to false if null
    );
  }

  @override
  Map<String, Object?> toJson() {
    final json = super.toJson();
    json.addAll({
      'brandType': brandType,
      'link': link,
      'approved': approved, // Include this field
    });
    return json;
  }
}
