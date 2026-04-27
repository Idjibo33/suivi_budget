import 'package:get_it/get_it.dart';
import 'package:suivi_budget/Core/services/local_auth.dart';
import 'package:suivi_budget/Core/services/user_pref.dart';

final getIt = GetIt.instance;
void locator() {
  getIt.registerSingleton<UserPref>(UserPref());
  getIt.registerSingleton<LocalAuth>(LocalAuth());
}
