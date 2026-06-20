import 'package:flutter_starter/core/errors/exceptions.dart';
import 'package:flutter_starter/modules/auth/domain/repository/local/local_user_session_repository.dart';
import 'package:flutter_starter/modules/auth/domain/repository/remote/auth_repository.dart';
import 'package:flutter_starter/modules/user/user.dart';

/// Dev stub. Accepts any non-empty credentials and fabricates a [UserEntity];
/// exercises the real Hive + secure-storage round-trip so the pipeline
/// (bloc → bootstrapper → state) is testable end-to-end without a backend.
///
/// To use: annotate with `@LazySingleton(as: AuthRepository)` and remove
/// that annotation from [RemoteAuthRepositoryImpl]. **Delete before shipping.**
class InMemoryAuthRepository implements AuthRepository {
  InMemoryAuthRepository(this._store);

  final LocalUserSessionRepository _store;

  @override
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw const AuthenticationException(
        message: 'Email and password are required',
      );
    }
    await _persistFakeSession(email: email);
  }

  @override
  Future<void> registerEmail({required String email}) async {
    if (email.isEmpty) {
      throw const AuthenticationException(message: 'Email is required');
    }
  }

  @override
  Future<void> registerUser({
    required String email,
    required String password,
    required String code,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw const AuthenticationException(message: 'Missing required fields');
    }
    await _persistFakeSession(email: email);
  }

  @override
  Future<void> forgetPassword({required String email}) async {
    if (email.isEmpty) {
      throw const AuthenticationException(message: 'Email is required');
    }
  }

  @override
  Future<void> resetPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    if (oldPassword.isEmpty || newPassword.isEmpty) {
      throw const AuthenticationException(
        message: 'Both passwords are required',
      );
    }
  }

  @override
  Future<void> loginWithGoogle() async {
    throw const AuthenticationException(
      message:
          'Google sign-in is not configured. Wire ThirdPartyAuthProvider in your AuthRepository implementation.',
    );
  }

  @override
  Future<void> loginWithApple() async {
    throw const AuthenticationException(
      message:
          'Apple sign-in is not configured. Wire ThirdPartyAuthProvider in your AuthRepository implementation.',
    );
  }

  @override
  Future<UserEntity?> getLoggedInUser() => _store.getUser();

  @override
  Stream<UserEntity?> watchUser() => _store.watchUser();

  @override
  Future<void> logout({bool wasStillAuthenticated = true}) =>
      _store.clearSession();

  Future<void> _persistFakeSession({required String email}) async {
    final user = UserEntity(
      id: email.hashCode,
      email: email,
      firstName: email.split('@').first,
      emailVerified: true,
    );
    await _store.saveSession(
      user: user,
      accessToken: 'fake-access-${email.hashCode}',
      refreshToken: 'fake-refresh-${email.hashCode}',
    );
  }
}
