import 'package:flutter/material.dart';
import 'package:suivi_budget/Core/get_it.dart';
import 'package:suivi_budget/Core/services/user_pref.dart';

class UserPrefsProvider extends ChangeNotifier {
  String? userInfos;
  final service = getIt<UserPref>();
  void saveUserInfos({required String newData}) async {
    try {
      await service.saveData(newData);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void getUserInfos() async {
    try {
      userInfos = await service.getData();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
