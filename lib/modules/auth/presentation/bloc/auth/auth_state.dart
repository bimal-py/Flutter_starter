part of 'auth_bloc.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

extension AuthStatusX on AuthStatus {
  bool get isInitial => this == AuthStatus.initial;
  bool get isAuthenticated => this == AuthStatus.authenticated;
  bool get isUnauthenticated => this == AuthStatus.unauthenticated;
}

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.session,
  });

  const AuthState.initial() : this();
  const AuthState.unauthenticated() : this(status: AuthStatus.unauthenticated);
  const AuthState.authenticated(UserEntity user, [AuthSessionEntity? session])
    : this(status: AuthStatus.authenticated, user: user, session: session);

  final AuthStatus status;
  final UserEntity? user;
  final AuthSessionEntity? session;

  bool get isAuthenticated => status.isAuthenticated && user != null;
  bool get isUnauthenticated => status.isUnauthenticated;

  List<String> get roles => session?.roles ?? const [];

  @override
  List<Object?> get props => [status, user, session];
}
