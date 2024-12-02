import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kyb/models/barcode.dart';

class DatabaseServiceBarcode {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Barcode> get barcodesRef => _firestore
      .collection('barcodes')
      .withConverter<Barcode>(
    fromFirestore: (snapshot, _) => Barcode.fromJson(snapshot.data()!),
    toFirestore: (barcode, _) => barcode.toJson(),
  );

  Future<void> addBarcode(Barcode barcode) async {
    await barcodesRef.add(barcode);
  }

  Future<void> updateBarcode(String id, Barcode barcode) async {
    await barcodesRef.doc(id).set(barcode);
  }

  Future<Barcode?> getBarcodeByNum(String barcodeNum) async {
    final querySnapshot = await barcodesRef
        .where('barcodeNum', isEqualTo: barcodeNum)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    }
    return null;
  }
}
