import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Firebase%20authentification%20service%20providers/connexion_service_provider.dart';
import 'package:suivi_budget/models/Snackbar%20Notifications/error_snackbar.dart';
import 'package:suivi_budget/models/Snackbar%20Notifications/success_snackbar.dart';
import 'package:suivi_budget/models/navigation/naviguer_auth_gate.dart';

void connecterUtilisateur({
  required BuildContext context,
  required String email,
  required String pw,
}) async {
  final connecionService = Provider.of<ConnexionServiceProvider>(
    context,
    listen: false,
  );
  try {
    final connexion = await connecionService.connecterUtilisateur(
      email: email,
      password: pw,
    );
    if (connexion) {
      if (context.mounted) {
        showSuccessSnackbar(context, connecionService.message);
        naviguerAuthGate(context);
      }
    } else {
      if (context.mounted) {
        showErrorSnackbar(context, connecionService.message);
      }
    }
  } catch (e) {
    if (context.mounted) {
      showErrorSnackbar(context, connecionService.message);
    }
  }
}
