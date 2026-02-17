import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suivi_budget/Services/Firebase%20database/Authentification%20services/auth_services.dart';
import 'package:suivi_budget/Services/Firebase%20database/Firestore%20services/firestore_services.dart';
import 'package:suivi_budget/models/transaction.dart';

class DocumentTransactionService {
  final FirestoreServices firestoreServices = FirestoreServices();
  String collectionTransaction = "transactions";
  String idUtilisateur = AuthServices().currentUser!.uid;
  //Ajouter un document transaction dans la collection Transactions
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

  // Charger les documents de la collection transaction
  Stream<List<TransactionModel>> lireDocsTransactions() {
    try {
      return firestoreServices.firebaseFirestore
          .collection(collectionTransaction)
          .orderBy("date", descending: true)
          .where("userId", isEqualTo: idUtilisateur)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return TransactionModel.fromMap(doc.data());
            }).toList();
          });
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }
}
