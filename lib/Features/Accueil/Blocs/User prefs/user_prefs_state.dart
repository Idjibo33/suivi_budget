part of 'user_prefs_bloc.dart';

@immutable
sealed class UserPrefsState extends Equatable {
  const UserPrefsState();
}

final class UserPrefsInitial extends UserPrefsState {
  const UserPrefsInitial();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

final class UserPrefsLoading extends UserPrefsState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

final class UserPrefsSaved extends UserPrefsState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

final class UserPrefsSuccess extends UserPrefsState {
  final String userName;
  const UserPrefsSuccess(this.userName);
  @override
  // TODO: implement props
  List<Object?> get props => [userName];
}

final class UserPrefsFailure extends UserPrefsState {
  final String message;
  const UserPrefsFailure(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
