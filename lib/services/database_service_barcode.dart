import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kyb/models/barcode.dart';

class DatabaseServiceBarcode {
  final _firestore = FirebaseFirestore.instance;
  final String BARCODES_COLLECTION_REF = 'barcodes';

  late final CollectionReference<Barcode> _barcodesRef;

  DatabaseServiceBarcode() {
    // Initialize collection reference with Firestore converters
    _barcodesRef = _firestore.collection(BARCODES_COLLECTION_REF).withConverter<Barcode>(
          fromFirestore: (snapshot, _) => Barcode.fromJson(snapshot.data()!),
          toFirestore: (barcode, _) => barcode.toJson(),
        );
  }

  /// Adds a barcode if it doesn't already exist
  Future<bool> addBarcode(Barcode barcode) async {
    try {
      // Check if barcode exists
      final querySnapshot = await _barcodesRef.where('barcodeNum', isEqualTo: barcode.barcodeNum).get();

      if (querySnapshot.docs.isEmpty) {
        // Add barcode to Firestore
        await _barcodesRef.add(barcode);
        return true; // Barcode successfully added
      } else {
        return false; // Barcode already exists
      }
    } catch (e) {
      throw Exception('Error adding barcode: $e');
    }
  }

  /// Checks if a barcode already exists
  Future<bool> checkBarcodeExists(String barcodeNum) async {
    try {
      final querySnapshot = await _barcodesRef.where('barcodeNum', isEqualTo: barcodeNum).get();
      return querySnapshot.docs.isNotEmpty; // Return true if a matching document is found
    } catch (e) {
      throw Exception('Error checking barcode: $e');
    }
  }
}
