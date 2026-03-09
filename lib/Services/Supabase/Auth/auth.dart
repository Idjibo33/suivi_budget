import 'package:suivi_budget/models/helpers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuth implements AuthServices {
  final _supabase = Supabase.instance.client;
  Stream<AuthState> authState() {
    return _supabase.auth.onAuthStateChange;
  }

  @override
  Future<dynamic> createAccountWithEmail(String email, String password) {
    // TODO: implement createAccountWithEmail
    throw UnimplementedError();
  }

  @override
  Future<dynamic> signInAnonymously() {
    // TODO: implement signInAnonymously
    throw UnimplementedError();
  }

  @override
  Future<dynamic> signInWithEmail(String email, String password) {
    // TODO: implement signInWithEmail
    throw UnimplementedError();
  }

  @override
  Future<dynamic> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
