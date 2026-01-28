import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SnackbarServices {
  static void successSnackbar(BuildContext context, message) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(message: message),
    );
    HapticFeedback.vibrate();
  }

  static void errorSnackbar(BuildContext context, message) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(message: message),
    );
    HapticFeedback.heavyImpact();
  }
}
