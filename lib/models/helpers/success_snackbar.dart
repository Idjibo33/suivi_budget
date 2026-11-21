import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suivi_budget/views/widgets/message_snackbar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void showSuccessSnackbar(BuildContext context, message) {
  showTopSnackBar(
    Overlay.of(context),
    MessageSnackbar(message: message.toString(), erreur: false),
  );
  HapticFeedback.vibrate();
}
