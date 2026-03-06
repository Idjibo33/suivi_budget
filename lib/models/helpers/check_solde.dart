import 'package:flutter/material.dart';
import 'package:suivi_budget/models/helpers/error_snackbar.dart';

bool balanceAvailable(int solde, int transactionAmount, BuildContext context) {
  if (solde < transactionAmount) {
    showErrorSnackbar(context, "Solde insuffisant");
    return false;
  } else {
    return true;
  }
}
