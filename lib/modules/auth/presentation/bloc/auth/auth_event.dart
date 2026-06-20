part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

class _AuthInitialCheckRequested extends AuthEvent {
  const _AuthInitialCheckRequested();
}

class _AuthUserChanged extends AuthEvent {
  const _AuthUserChanged(this.user);
  final UserEntity? user;
}

class _AuthLogoutRequested extends AuthEvent {
  const _AuthLogoutRequested({required this.wasStillAuthenticated});
  final bool wasStillAuthenticated;
}
