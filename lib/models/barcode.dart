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
      companyName: (json['companyName'] as String).trim().toLowerCase(), // Normalize to lowercase
      category: (json['category'] as String).trim(),
      brandType: (json['brandType'] as String?)?.trim(),
      evidenceLink: (json['evidenceLink'] as String?)?.trim(),
      approved: json['approved'] is bool ? json['approved'] as bool : null, // Ensure type safety
    );
  }

  /// Method to convert to JSON
  Map<String, Object?> toJson() {
    final Map<String, Object?> json = {
      'barcodeNum': barcodeNum.trim(),
      'companyName': companyName.trim().toLowerCase(),
      'category': category.trim(),
    };

    if (brandType?.isNotEmpty ?? false) {
      json['brandType'] = brandType?.trim();
    }
    if (evidenceLink?.isNotEmpty ?? false) {
      json['evidenceLink'] = evidenceLink?.trim();
    }
    if (approved != null) {
      json['approved'] = approved;
    }

    return json;
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

  /// Helper to check if the barcode data is valid
  bool isValid() {
    return barcodeNum.isNotEmpty && companyName.isNotEmpty && category.isNotEmpty;
  }
}
