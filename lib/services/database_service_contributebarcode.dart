import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kyb/models/contribute_barcode.dart';

const String CONTRIBUTE_BARCODES_COLLECTION_REF = 'contribute_barcodes';

class DatabaseServiceContributeBarcode {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference<ContributeBarcode> _contributeBarcodesRef;

  DatabaseServiceContributeBarcode() {
    _contributeBarcodesRef = _firestore.collection(CONTRIBUTE_BARCODES_COLLECTION_REF).withConverter<ContributeBarcode>(
          fromFirestore: (snapshot, _) => ContributeBarcode.fromJson(snapshot.data()!),
          toFirestore: (contributeBarcode, _) => contributeBarcode.toJsonWithLowercase(),
        );
  }

  Stream<QuerySnapshot<ContributeBarcode>> getContributeBarcodes() {
    return _contributeBarcodesRef.snapshots();
  }

  Future<void> addContributeBarcode(ContributeBarcode contributeBarcode) async {
    final QuerySnapshot<ContributeBarcode> querySnapshot = await _contributeBarcodesRef.where('barcodeNum', isEqualTo: contributeBarcode.barcodeNum).get();

    if (querySnapshot.docs.isEmpty) {
      await _contributeBarcodesRef.add(contributeBarcode);
    } else {
      print('Contribute barcode already exists');
    }
  }
}
