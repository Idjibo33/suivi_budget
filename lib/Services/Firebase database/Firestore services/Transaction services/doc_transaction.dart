import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suivi_budget/Services/Firebase%20database/Authentification%20services/auth.dart';
import 'package:suivi_budget/Services/Firebase%20database/Firestore%20services/firestore.dart';
import 'package:suivi_budget/models/transaction.dart';

class DocTransaction {
  final Firestore firestoreServices = Firestore();
  String collectionTransaction = "transactions";
  String idUtilisateur = Auth().currentUser!.uid;
  //Ajouter un document transaction dans la collection Transactions
  Future<void> creerDocTransaction(TransactionModel transaction) async {
    try {
      final ref = firestoreServices.firebaseFirestore
          .collection(collectionTransaction)
          .doc();
      final donnee = {
        'id': ref.id,
        'userId': transaction.userId,
        'montant': transaction.montant,
        'description': transaction.description,
        'category': transaction.category,
        'type': transaction.type,
        'date': transaction.date,
      };
      return await ref.set(donnee);
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  // Supprimer la transaction
  Future supprimerTransaction(String id) async {
    try {
      await firestoreServices.firebaseFirestore
          .collection(collectionTransaction)
          .doc(id)
          .delete();
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
              return TransactionModel.fromMap(doc);
            }).toList();
          });
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }
}
