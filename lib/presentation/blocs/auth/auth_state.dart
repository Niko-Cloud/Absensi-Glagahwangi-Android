part of 'auth_bloc.dart';

enum AuthStatus { authenticated, unauthenticated }
class AuthState extends Equatable {
  final AuthStatus status;
  final User user;

  const AuthState._({
    this.status = AuthStatus.unauthenticated,
    this.user = User.empty,
  });

  const AuthState.authenticated(User user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated() : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object?> get props => [status, user];
}