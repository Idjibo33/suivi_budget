import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Firestore%20services%20provider/doc_utilisateur_provider.dart';
import 'package:suivi_budget/models/Snackbar%20Notifications/success_snackbar.dart';

Future chargerDocUtilisateur(BuildContext context) async {
  final docUtilisateurProvider = Provider.of<DocUtilisateurProvider>(
    context,
    listen: false,
  );
  try {
    final chargement = await docUtilisateurProvider.chargerDocUtilisateur();
    if (!chargement) {
      if (context.mounted) {
        showSuccessSnackbar(context, docUtilisateurProvider.message);
      }
    }
  } catch (e) {
    if (context.mounted) {
      showSuccessSnackbar(context, docUtilisateurProvider.message);
    }
  }
}
