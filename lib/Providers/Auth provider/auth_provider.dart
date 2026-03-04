import 'package:flutter/material.dart';
import 'package:suivi_budget/Services/Auth/auth.dart';

class AuthProvider extends ChangeNotifier {
  final Auth _auth = Auth();
}
