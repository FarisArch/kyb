import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kyb/models/barcode.dart';

class DatabaseServiceBarcode {
  final _firestore = FirebaseFirestore.instance;
  final String BARCODES_COLLECTION_REF = 'barcodes';

  late final CollectionReference _barcodesRef;

  DatabaseServiceBarcode() {
    _barcodesRef = _firestore.collection(BARCODES_COLLECTION_REF).withConverter<Barcode>(
          fromFirestore: (snapshot, _) => Barcode.fromJson(snapshot.data()!),
          toFirestore: (barcode, _) => barcode.toJson(),
        );
  }

  Future<bool> addBarcode(Barcode barcode) async {
    final QuerySnapshot querySnapshot = await _barcodesRef.where('barcodeNum', isEqualTo: barcode.barcodeNum).get();

    if (querySnapshot.docs.isEmpty) {
      // Normalize data before adding to Firestore
      final normalizedBarcode = Barcode(
        barcodeNum: barcode.barcodeNum,
        companyName: barcode.companyName,
        category: barcode.category,
      );

      // Convert and add lowercase fields
      final data = normalizedBarcode.toJson();
      data['companyNameLowercase'] = barcode.companyName.toLowerCase(); // Add normalized field

      await _barcodesRef.add(data);
      return false; // Barcode was added
    } else {
      return true; // Barcode exists, no changes made
    }
  }

  Future<bool> checkBarcodeExists(String barcode) async {
    final QuerySnapshot querySnapshot = await _barcodesRef.where('barcodeNum', isEqualTo: barcode).get();
    return querySnapshot.docs.isNotEmpty; // Returns true if barcode exists
  }
}
