import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suivi_budget/models/helpers.dart';
import 'package:suivi_budget/models/transaction.dart';

class DocTransaction implements Databaseervices<TransactionModel> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String collectionTransaction = "transactions";

  @override
  Future createData(TransactionModel item) async {
    final ref = firestore.collection(collectionTransaction).doc();
    final donnee = {
      'id': ref.id,
      'userId': item.userId,
      'montant': item.montant,
      'description': item.description,
      'category': item.category,
      'type': item.type,
      'date': item.date,
    };
    return await ref.set(donnee);
  }

  @override
  Future deleteData(String id) async {
    await firestore.collection(collectionTransaction).doc(id).delete();
  }

  @override
  Stream<List<TransactionModel>> readData() {
    return firestore
        .collection(collectionTransaction)
        .orderBy("date", descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return TransactionModel.fromMap(doc);
          }).toList();
        });
  }

  @override
  Future updateData(String id, TransactionModel item) async {
    await firestore
        .collection(collectionTransaction)
        .doc(item.id)
        .update(item.toMap());
  }

  @override
  Future<dynamic> readDataOnce() {
    // TODO: implement readDataOnce
    throw UnimplementedError();
  }
}
