import 'package:flutter/material.dart';
import 'package:suivi_budget/Core/constants.dart';
import 'package:suivi_budget/models/navigation/naviguer_ajouter_transaction_page.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        naviguerAjouterTransactionPage(context);
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: couleurTexteSecondaire, blurRadius: 10)],
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: AlignmentGeometry.topLeft,
            end: AlignmentGeometry.bottomRight,
            colors: gradient2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
