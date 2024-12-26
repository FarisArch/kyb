import 'package:kyb/models/barcode.dart';

class ContributeBarcode extends Barcode {
  final String brandType;
  final String evidenceLink;
  final bool approved;

  ContributeBarcode({
    required String barcodeNum,
    required String companyName,
    required String category,
    required this.brandType,
    required this.evidenceLink,
    this.approved = false,
  }) : super(
          barcodeNum: barcodeNum.toLowerCase(),
          companyName: companyName.toLowerCase(),
          category: category.toLowerCase(),
        );

  @override
  factory ContributeBarcode.fromJson(Map<String, Object?> json) {
    return ContributeBarcode(
      barcodeNum: (json['barcodeNum']! as String).toLowerCase(),
      companyName: (json['companyName']! as String).toLowerCase(),
      category: (json['category']! as String).toLowerCase(),
      brandType: (json['brandType']! as String).toLowerCase(),
      evidenceLink: (json['evidenceLink']! as String).toLowerCase(),
      approved: json['approved'] as bool? ?? false,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final json = super.toJson();
    json.addAll({
      'brandType': brandType,
      'evidenceLink': evidenceLink,
      'approved': approved,
    });
    return json;
  }

  /// Converts all string fields to lowercase in JSON format
  Map<String, Object?> toJsonWithLowercase() {
    final json = super.toJson();
    json.addAll({
      'brandType': brandType.toLowerCase(),
      'evidenceLink': evidenceLink.toLowerCase(),
      'approved': approved,
    });
    return json;
  }
}
