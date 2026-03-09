import 'package:suivi_budget/models/helpers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuth implements AuthServices {
  final _supabase = Supabase.instance.client;
  Stream<AuthState> authState() {
    return _supabase.auth.onAuthStateChange;
  }

  @override
  Future<AuthResponse> createAccountWithEmail(String email, String password) {
    return _supabase.auth.signUp(email: email, password: password);
  }

  @override
  Future<AuthResponse> signInAnonymously() {
    return _supabase.auth.signInAnonymously();
  }

  @override
  Future<dynamic> signInWithEmail(String email, String password) {
    return _supabase.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future signOut() {
    return _supabase.auth.signOut();
  }
}
