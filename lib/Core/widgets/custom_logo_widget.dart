import 'package:flutter/material.dart';
import 'package:suivi_budget/Core/constants.dart';

class CustomLogoWidget extends StatelessWidget {
  final double size;
  const CustomLogoWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: couleurbgSecondaire,
      ),
      child: Image.asset(
        "asset/logo/image.png",
        fit: BoxFit.cover,
        height: size,
        width: size,
      ),
    );
  }
}
