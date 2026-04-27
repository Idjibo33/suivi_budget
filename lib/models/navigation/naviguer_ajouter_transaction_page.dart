import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suivi_budget/Features/transactions/presentation/screens/transaction_screen.dart';

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
