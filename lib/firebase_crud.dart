import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// ignore: non_constant_identifier_names
final CollectionReference _Collection = _firestore.collection('pricelist');

class FirebaseCrud {
//CRUD method here
  static Stream<QuerySnapshot> readPricelist() {
    CollectionReference notesItemCollection = _Collection;

    return notesItemCollection.snapshots();
  }
}
