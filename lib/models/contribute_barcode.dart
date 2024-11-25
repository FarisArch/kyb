import 'package:kyb/models/barcode.dart';

class ContributeBarcode extends Barcode {
  final String brandType;
  final String link;

  ContributeBarcode({
    required String barcodeNum,
    required String companyName,
    required String category,
    required this.brandType,
    required this.link,
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
    );
  }

  @override
  Map<String, Object?> toJson() {
    final json = super.toJson();
    json.addAll({
      'brandType': brandType,
      'link': link,
    });
    return json;
  }
}
