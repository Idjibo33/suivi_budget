import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';

class CustomLogoWidget extends StatelessWidget {
  final double padding;
  final double size;
  const CustomLogoWidget({
    super.key,
    required this.padding,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: couleurbgSecondaire,
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Icon(Icons.wallet, size: size, color: couleurRevenu),
      ),
    );
  }
}
