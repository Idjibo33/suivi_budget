import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suivi_budget/auth_gate.dart';

void naviguerAuthGate(BuildContext context) {
  if (Platform.isIOS) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => AuthGate()),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AuthGate()),
    );
  }
}
