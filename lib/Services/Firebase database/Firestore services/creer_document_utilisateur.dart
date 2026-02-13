import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:suivi_budget/Services/Firebase%20database/Firestore%20services/firestore_services.dart';

class CreerDocumentUtilisateur {
  final FirestoreServices firestore = FirestoreServices();
  String utilisateurCollection = 'utilisateurs';
  //Creer le document de l'utilisateur dans la collection utilisateurs
  Future creerDocUtilisateur({
    required String idUtilisateur,
    required String nom,
    required String prenom,
    required String email,
  }) async {
    final donnee = {
      'id': idUtilisateur,
      'nom': nom,
      'prenom': prenom,
      'email': email,
    };
    try {
      await firestore.firebaseFirestore
          .collection(utilisateurCollection)
          .doc(idUtilisateur)
          .set(donnee);
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }
}
