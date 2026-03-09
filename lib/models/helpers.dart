import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

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
  Future updateData(T item);
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

void showErrorSnackbar(BuildContext context, message) {
  showTopSnackBar(Overlay.of(context), CustomSnackBar.error(message: message));
  HapticFeedback.heavyImpact();
}

void showSuccessSnackbar(BuildContext context, message) {
  showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.success(message: message),
  );
  HapticFeedback.vibrate();
}

String formatDate(DateTime date) {
  final dateFormating = DateFormat.yMMMMEEEEd().format(date);
  final hourFormating = DateFormat.Hm().format(date);
  return "$dateFormating à $hourFormating";
}
