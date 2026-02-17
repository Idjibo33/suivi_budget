import 'package:flutter/material.dart';
import 'package:suivi_budget/Services/Firebase%20database/Authentification%20services/auth.dart';

class AuthProvider extends ChangeNotifier {
  final Auth authServices = Auth();
}
