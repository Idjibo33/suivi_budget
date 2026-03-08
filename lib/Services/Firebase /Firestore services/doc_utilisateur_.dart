import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suivi_budget/models/helpers.dart';
import 'package:suivi_budget/models/utilisateur.dart';

class DocUtilisateur implements Databaseervices<Utilisateur> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String utilisateurCollection = 'utilisateurs';

  @override
  Future createData(Utilisateur item) async {
    await firestore
        .collection(utilisateurCollection)
        .doc(item.userId)
        .set(item.toMap());
  }

  @override
  Future<dynamic> deleteData(String id) {
    // TODO: implement deleteData
    throw UnimplementedError();
  }

  @override
  Stream<Utilisateur> readData() {
    return firestore
        .collection(utilisateurCollection)
        .doc()
        .snapshots()
        .map((snapshot) => Utilisateur.fromMap(snapshot.data()!));
  }

  @override
  Future<dynamic> updateData(String id, Utilisateur item) async {
    await firestore
        .collection(utilisateurCollection)
        .doc(id)
        .update(item.toMap());
  }

  @override
  Future<Utilisateur> readDataOnce() async {
    return firestore.collection(utilisateurCollection).doc().get().then((
      value,
    ) {
      return Utilisateur.fromMap(value.data()!);
    });
  }
}
