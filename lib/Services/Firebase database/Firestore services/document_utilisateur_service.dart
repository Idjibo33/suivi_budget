import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suivi_budget/Services/Firebase%20database/Authentification%20services/auth_services.dart';
import 'package:suivi_budget/Services/Firebase%20database/Firestore%20services/firestore_services.dart';
import 'package:suivi_budget/models/utilisateur.dart';

class DocumentUtilisateurService {
  final FirestoreServices firestoreServices = FirestoreServices();
  String get utilisateurDoc => AuthServices().currentUser!.uid;
  String utilisateurCollection = 'utilisateurs';

  Future<Utilisateur?> lireDocUtilisateur() async {
    try {
      final resultat = await firestoreServices.firebaseFirestore
          .collection(utilisateurCollection)
          .doc(utilisateurDoc)
          .get();
      final utilisateur = resultat.data();
      if (utilisateur == null) {
        return null;
      }
      return Utilisateur.fromMap(utilisateur);
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }
}
