import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Firebase%20authentification%20service%20providers/deconnexion_services_provider.dart';
import 'package:suivi_budget/models/Snackbar%20Notifications/error_snackbar.dart';
import 'package:suivi_budget/models/Snackbar%20Notifications/success_snackbar.dart';
import 'package:suivi_budget/models/navigation/naviguer_auth_gate.dart';

void deconnecterUtilisateur({required BuildContext context}) async {
  final deconnecionService = Provider.of<DeconnexionServicesProvider>(
    context,
    listen: false,
  );
  try {
    final deconnexion = await deconnecionService.deconnecterUtilisateur();
    if (deconnexion) {
      if (context.mounted) {
        showSuccessSnackbar(context, deconnecionService.message);
        naviguerAuthGate(context);
      }
    } else {
      if (context.mounted) {
        showErrorSnackbar(context, deconnecionService.message);
      }
    }
  } catch (e) {
    if (context.mounted) {
      showErrorSnackbar(context, deconnecionService.message);
    }
  }
}
