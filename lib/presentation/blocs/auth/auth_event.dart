part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthUserChanged extends AuthEvent {
  final UserEntity user;

  const AuthUserChanged(this.user);

  @override
  List<Object> get props => [user];
}

class FetchUserData extends AuthEvent {
  const FetchUserData();
}
