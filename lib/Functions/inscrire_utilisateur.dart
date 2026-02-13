import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Firebase%20authentification%20service%20providers/inscription_service_provider.dart';
import 'package:suivi_budget/models/Snackbar%20Notifications/error_snackbar.dart';
import 'package:suivi_budget/models/Snackbar%20Notifications/success_snackbar.dart';

void inscrireUtilisateur({
  required BuildContext context,
  required String nom,
  required String prenom,
  required String email,
  required String pw,
}) async {
  final inscriptionService = Provider.of<InscriptionServiceProvider>(
    context,
    listen: false,
  );
  try {
    final insciption = await inscriptionService.inscrireUtilisateur(
      nom: nom,
      prenom: prenom,
      email: email,
      password: pw,
    );
    if (insciption) {
      if (context.mounted) {
        showSuccessSnackbar(context, inscriptionService.message);
      }
    } else {
      if (context.mounted) {
        showErrorSnackbar(context, inscriptionService.message);
      }
    }
  } catch (e) {
    if (context.mounted) {
      showErrorSnackbar(context, inscriptionService.message);
    }
  }
}
