import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suivi_budget/auth_gate.dart';

void naviguerAuthGate(BuildContext context) {
  if (Platform.isIOS) {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoDialogRoute(builder: (context) => AuthGate(), context: context),
      (route) => false,
    );
  } else {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthGate()),
      (route) => false,
    );
  }
}
