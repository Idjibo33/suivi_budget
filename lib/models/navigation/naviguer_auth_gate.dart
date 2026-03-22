import 'package:flutter/material.dart';
import 'package:suivi_budget/auth_gate.dart';

void naviguerAuthGate(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => AuthGate()),
    (route) => false,
  );
}
