import 'package:get_it/get_it.dart';
import 'package:suivi_budget/Services/Preferences/user_pref.dart';

final getIt = GetIt.instance;
void locator() {
  getIt.registerSingleton<UserPref>(UserPref());
}
