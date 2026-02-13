import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';

class CustomLogoWidget extends StatelessWidget {
  const CustomLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Styles.couleurbgSecondaire,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Icon(Icons.wallet, size: 50, color: Styles.couleurRevenu),
      ),
    );
  }
}
