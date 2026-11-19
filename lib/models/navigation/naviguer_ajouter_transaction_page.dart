import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:suivi_budget/views/widgets/ajouter_transaction_widget.dart';

void naviguerAjouterTransactionPage(BuildContext context) {
  final bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;
  Navigator.push(
    context,
    isIOS
        ? CupertinoPageRoute<void>(
            builder: (context) => const AjouterTransaction(),
          )
        : MaterialPageRoute<void>(
            builder: (context) => const AjouterTransaction(),
          ),
  );
}
