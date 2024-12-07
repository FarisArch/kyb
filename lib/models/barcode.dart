class Barcode {
  String barcodeNum;
  String companyName;
  String category;
  String? brandType; // Optional field
  String? evidenceLink; // Optional field
  bool? approved; // Optional field to indicate approval status

  Barcode({
    required this.barcodeNum,
    required this.companyName,
    required this.category,
    this.brandType,
    this.evidenceLink,
    this.approved,
  });

  /// Factory constructor to initialize from JSON
  factory Barcode.fromJson(Map<String, Object?> json) {
    return Barcode(
      barcodeNum: (json['barcodeNum'] as String).trim(),
      companyName: (json['companyName'] as String).trim(),
      category: (json['category'] as String).trim(),
      brandType: (json['brandType'] as String?)?.trim(),
      evidenceLink: (json['evidenceLink'] as String?)?.trim(),
      approved: json['approved'] as bool?,
    );
  }

  /// Method to convert to JSON
  Map<String, Object?> toJson() {
    return {
      'barcodeNum': barcodeNum.trim(),
      'companyName': companyName.trim().toLowerCase(), // Normalize to lowercase
      'category': category.trim(),
      'brandType': brandType?.trim(),
      'evidenceLink': evidenceLink?.trim(),
      'approved': approved,
    };
  }

  /// Method for creating a copy with updated fields
  Barcode copyWith({
    String? barcodeNum,
    String? companyName,
    String? category,
    String? brandType,
    String? evidenceLink,
    bool? approved,
  }) {
    return Barcode(
      barcodeNum: barcodeNum ?? this.barcodeNum,
      companyName: companyName?.toLowerCase().trim() ?? this.companyName,
      category: category?.trim() ?? this.category,
      brandType: brandType?.trim() ?? this.brandType,
      evidenceLink: evidenceLink?.trim() ?? this.evidenceLink,
      approved: approved ?? this.approved,
    );
  }
}
