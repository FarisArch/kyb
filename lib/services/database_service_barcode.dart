import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kyb/models/barcode.dart';

const String BARCODES_COLLECTION_REF = 'barcodes';

class DatabaseServiceBarcode {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _barcodesRef;
  DatabaseServiceBarcode() {
    _barcodesRef = _firestore.collection(BARCODES_COLLECTION_REF).withConverter<Barcode>(fromFirestore: (snapshot, _) => Barcode.fromJson(snapshot.data()!), toFirestore: (barcode, _) => barcode.toJson());
  }
  Stream<QuerySnapshot<Barcode>> getBarcodes() {
    return _barcodesRef
        .withConverter<Barcode>(
          fromFirestore: (snapshot, _) => Barcode.fromJson(snapshot.data()!),
          toFirestore: (barcode, _) => barcode.toJson(),
        )
        .snapshots();
  }

  void addBarcode(Barcode barcode) async {
    final QuerySnapshot querySnapshot = await _barcodesRef.where('barcodeNum', isEqualTo: barcode.barcodeNum).get();
    if (querySnapshot.docs.isEmpty) {
      _barcodesRef.add(barcode);
    } else {
      print('Barcode already exists');
    }
  }
}
