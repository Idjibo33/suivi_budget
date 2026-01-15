import 'package:shared_preferences/shared_preferences.dart';

class UtilisateurPreferences {
  static const String key = "nom_utilisateur";

  Future enregistrerNom(String nouveauNom) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, nouveauNom);
  }

  Future<String?> lireNom() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}
