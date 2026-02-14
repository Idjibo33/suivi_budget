import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suivi_budget/Services/Firebase%20database/Firestore%20services/firestore_services.dart';
import 'package:suivi_budget/models/transaction.dart';

class DocumentTransactionService {
  final FirestoreServices firestoreServices = FirestoreServices();
  String collectionTransaction = "transactons";
  //Ajouter le document transaction
  Future<DocumentReference?> creerDocTransaction(
    TransactionModel transaction,
  ) async {
    try {
      return await firestoreServices.firebaseFirestore
          .collection(collectionTransaction)
          .add(transaction.toMap());
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }
}
