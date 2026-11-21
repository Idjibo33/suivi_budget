import 'package:flutter/material.dart';

/// Seuils partagés par la coque adaptative et les panneaux grand écran.
class Responsive {
  const Responsive._();

  static const double mobileMax = 600;
  static const double tableauMax = 1000;
  static const double dialogueMin = 900;

  static bool estGrandEcran(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= dialogueMin;
}
