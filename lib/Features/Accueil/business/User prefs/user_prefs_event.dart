part of 'user_prefs_bloc.dart';

@immutable
sealed class UserPrefsEvent {}

final class FetchUserPrefs extends UserPrefsEvent {}

final class SaveUserPrefs extends UserPrefsEvent {
  final String userName;
  SaveUserPrefs(this.userName);
}
