import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kyb/models/contribute_barcode.dart';

const String CONTRIBUTE_BARCODES_COLLECTION_REF = 'contribute_barcodes';

class DatabaseServiceContributeBarcode {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _contributeBarcodesRef;
  DatabaseServiceContributeBarcode() {
    _contributeBarcodesRef = _firestore.collection(CONTRIBUTE_BARCODES_COLLECTION_REF).withConverter<ContributeBarcode>(
          fromFirestore: (snapshot, _) => ContributeBarcode.fromJson(snapshot.data()!),
          toFirestore: (contributeBarcode, _) => contributeBarcode.toJson(),
        );
  }

  Stream<QuerySnapshot<ContributeBarcode>> getContributeBarcodes() {
    return _contributeBarcodesRef
        .withConverter<ContributeBarcode>(
          fromFirestore: (snapshot, _) => ContributeBarcode.fromJson(snapshot.data()!),
          toFirestore: (contributeBarcode, _) => contributeBarcode.toJson(),
        )
        .snapshots();
  }

  void addContributeBarcode(ContributeBarcode contributeBarcode) async {
    final QuerySnapshot querySnapshot = await _contributeBarcodesRef.where('barcodeNum', isEqualTo: contributeBarcode.barcodeNum).get();
    if (querySnapshot.docs.isEmpty) {
      _contributeBarcodesRef.add(contributeBarcode);
    } else {
      print('Contribute barcode already exists');
    }
  }
}
