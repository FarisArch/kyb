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
      // If the barcode is "No barcode", do not check in Firestore, just check the company.
      if (barcode.barcodeNum == 'No barcode') {
        bool companyExists = await checkCompanyExists(barcode.companyName);
        if (companyExists) {
          print('Company ${barcode.companyName} already exists!');
          return false; // Don't add, since the company exists
        } else {
          print('Company ${barcode.companyName} does not exist. Adding barcode with "No barcode".');
          await _barcodesRef.add(barcode); // Add with "No barcode"
          return true; // Barcode successfully added
        }
      } else {
        // If barcode is not "No barcode", proceed with checking if it exists
        final querySnapshot = await _barcodesRef.where('barcodeNum', isEqualTo: barcode.barcodeNum).get();
        print('Checking if barcode exists: ${barcode.barcodeNum}');

        if (querySnapshot.docs.isEmpty) {
          print('Barcode does not exist. Proceeding to add...');
          await _barcodesRef.add(barcode);
          return true; // Barcode successfully added
        } else {
          print('Barcode already exists: ${barcode.barcodeNum}');
          return false; // Barcode already exists
        }
      }
    } catch (e) {
      print('Error adding barcode: $e');
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

  /// Checks if a company name already exists in the database
  Future<bool> checkCompanyExists(String companyName) async {
    try {
      final querySnapshot = await _barcodesRef.where('companyName', isEqualTo: companyName).get();
      print('Checking if company exists: $companyName');
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking company existence: $e');
      throw Exception('Error checking company: $e');
    }
  }
}
