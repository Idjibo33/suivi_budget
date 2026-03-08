import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:suivi_budget/models/error_snackbar.dart';
import 'package:suivi_budget/models/transaction.dart';

abstract class AuthServices {
  Future createAccountWithEmail(String email, String password);
  Future signInWithEmail(String email, String password);
  Future signInAnonymously();
  Future signOut();
}

bool validateBalance(
  int solde,
  TransactionModel transaction,
  BuildContext context,
) {
  if (transaction.type == "Depense") {
    if (solde < transaction.montant) {
      showErrorSnackbar(context, "Solde insuffisant");
      return false;
    }
    return true;
  } else {
    return true;
  }
}

abstract class Databaseervices<T> {
  Future createData(T item);
  Future updateData(String id, T item);
  Future deleteData(String id);
  Stream readData();
  Future readDataOnce();
}

bool validateUserCreationForm(
  BuildContext context,
  String nom,
  String prenom,
  String email,
  String password,
  String confPassword,
) {
  if (nom.isEmpty ||
      prenom.isEmpty ||
      email.isEmpty ||
      password.isEmpty ||
      confPassword.isEmpty) {
    showErrorSnackbar(context, "Toutes les cases sont obligatoires");
    return false;
  }
  if (password != confPassword) {
    showErrorSnackbar(context, "Les mots de passe ne correspondent pas");
    return false;
  }
  return true;
}

bool validateUserConnexinForm(
  BuildContext context,
  String email,
  String password,
) {
  if (email.isEmpty || password.isEmpty) {
    showErrorSnackbar(context, "Toutes les cases sont obligatoires");
    return false;
  }
  return true;
}
