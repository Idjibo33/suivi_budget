import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static const Color couleurRevenu = Colors.green;
  static const Color couleurDepense = Colors.red;
  static const Color couleurbgSecondaire = Color.fromRGBO(214, 214, 214, 1);

  static TextStyle texteEnTete = GoogleFonts.averiaSansLibre(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    letterSpacing: 5,
  );
  static TextStyle texteTitre = GoogleFonts.averiaSansLibre(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static TextStyle texteCorps = GoogleFonts.averiaSansLibre(
    fontSize: 16,
    color: Colors.grey,
  );
}
