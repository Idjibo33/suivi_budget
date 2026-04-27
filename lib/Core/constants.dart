import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color couleurRevenu = Color.fromRGBO(114, 184, 150, 2);
const Color couleurTextePrimaire = Colors.black87;
const Color couleurTexteSecondaire = Colors.grey;
const Color couleurDepense = Color.fromRGBO(205, 68, 57, 1);
const Color couleurbgSecondaire = Color.fromRGBO(214, 214, 214, 1);
final List<Color> gradient1 = [
  Colors.yellow.shade100,
  couleurRevenu,
  Colors.grey.shade700,
];
final List<Color> gradient2 = [
  Colors.grey.shade700,
  couleurRevenu,
  Colors.yellow.shade100,
];

final TextStyle texteEnTete = GoogleFonts.averiaSansLibre(
  fontSize: 25,
  fontWeight: FontWeight.bold,
  letterSpacing: 5,
);
final TextStyle texteTitre = GoogleFonts.averiaSansLibre(
  fontSize: 18,
  fontWeight: FontWeight.bold,
);
final TextStyle texteCorps = GoogleFonts.averiaSansLibre(
  fontSize: 14,
  color: couleurTexteSecondaire,
);
