import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:suivi_budget/Core/get_it.dart';
import 'package:suivi_budget/Services/Preferences/user_pref.dart';

part 'user_prefs_event.dart';
part 'user_prefs_state.dart';

class UserPrefsBloc extends Bloc<UserPrefsEvent, UserPrefsState> {
  UserPrefsBloc() : super(UserPrefsInitial()) {
    on<FetchUserPrefs>((event, emit) async {
      try {
        emit(UserPrefsLoading());
        final String userName = await getIt<UserPref>().getData();
        emit(UserPrefsSuccess(userName));
      } catch (e) {
        emit(UserPrefsFailure(e.toString()));
      }
    });

    on<SaveUserPrefs>((event, emit) async {
      try {
        emit(UserPrefsLoading());
        await getIt<UserPref>().saveData(event.userName);
        emit(UserPrefsSaved());
      } catch (e) {
        emit(UserPrefsFailure(e.toString()));
      }
    });
  }
}
