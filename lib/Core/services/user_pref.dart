import 'package:shared_preferences/shared_preferences.dart';

class UserPref {
  final String key = 'User Name';
  Future saveData(String newName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, newName);
  }

  Future<String> getData() async {
    final prefs = await SharedPreferences.getInstance();
    String name = prefs.getString(key) ?? "Utilisateur";
    return name;
  }
}
