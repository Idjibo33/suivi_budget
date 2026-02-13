import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suivi_budget/views/Authentification/inscription_page.dart';

void naviguerInscriptionPage(BuildContext context) {
  if (Platform.isIOS) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => InscriptionPage()),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InscriptionPage()),
    );
  }
}
