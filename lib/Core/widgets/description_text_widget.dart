import 'package:flutter/material.dart';
import 'package:suivi_budget/Core/constants.dart';

Widget descriptionText({required String text, TextAlign? textalignment}) {
  return Text(text, style: texteCorps, textAlign: textalignment);
}
