import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';

Widget descriptionText({required String text, TextAlign? textalignment}) {
  return Text(text, style: texteCorps, textAlign: textalignment);
}
