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

  // Factory constructor to initialize from JSON
  Barcode.fromJson(Map<String, Object?> json)
      : this(
          barcodeNum: json['barcodeNum']! as String,
          companyName: json['companyName']! as String,
          category: json['category']! as String,
          brandType: json['brandType'] as String?,
          evidenceLink: json['evidenceLink'] as String?,
          approved: json['approved'] as bool?,
        );

  // Method to convert to JSON
  Map<String, Object?> toJson() {
    return {
      'barcodeNum': barcodeNum,
      'companyName': companyName,
      'category': category,
      'brandType': brandType,
      'evidenceLink': evidenceLink,
      'approved': approved,
    };
  }

  // Method for creating a copy with updated fields
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
      companyName: companyName ?? this.companyName,
      category: category ?? this.category,
      brandType: brandType ?? this.brandType,
      evidenceLink: evidenceLink ?? this.evidenceLink,
      approved: approved ?? this.approved,
    );
  }
}
