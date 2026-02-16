import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suivi_budget/views/widgets/ajouter_transaction_widget.dart';

void naviguerAjouterTransactionPage(BuildContext context) {
  if (Platform.isIOS) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => AjouterTransaction()),
    );
  }
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AjouterTransaction()),
  );
}
