import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Firestore%20services%20provider/doc_transaction_service_provider.dart';
import 'package:suivi_budget/models/Snackbar%20Notifications/error_snackbar.dart';
import 'package:suivi_budget/models/Snackbar%20Notifications/success_snackbar.dart';
import 'package:suivi_budget/models/transaction.dart';

Future creerTransaction({
  required BuildContext context,
  required TransactionModel transaction,
}) async {
  final DocTransactionServiceProvider transactionService =
      Provider.of<DocTransactionServiceProvider>(context, listen: false);
  try {
    final creationDoc = await transactionService.creerDocTransaction(
      transaction,
    );
    if (creationDoc) {
      if (context.mounted) {
        showSuccessSnackbar(context, transactionService.message);
      }
    } else {
      if (context.mounted) {
        showErrorSnackbar(context, transactionService.message);
      }
    }
  } catch (e) {
    if (context.mounted) {
      showErrorSnackbar(context, transactionService.message);
    }
  }
}
