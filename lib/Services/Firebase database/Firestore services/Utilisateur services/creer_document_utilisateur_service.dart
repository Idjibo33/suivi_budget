import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:suivi_budget/Services/Firebase%20database/Firestore%20services/firestore_services.dart';
import 'package:suivi_budget/models/utilisateur.dart';

class CreerDocumentUtilisateurService {
  final FirestoreServices firestore = FirestoreServices();
  String utilisateurCollection = 'utilisateurs';
  //Creer le document de l'utilisateur dans la collection utilisateurs
  Future creerDocUtilisateur({required Utilisateur utilisateur}) async {
    try {
      await firestore.firebaseFirestore
          .collection(utilisateurCollection)
          .doc(utilisateur.userId)
          .set(utilisateur.toMap());
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }
}
