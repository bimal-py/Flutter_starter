import 'package:flutter_starter/modules/auth/domain/entity/auth_session_entity.dart';
import 'package:flutter_starter/modules/user/user.dart';

abstract class LocalUserSessionRepository {
  Future<void> saveUser(UserEntity user);
  Future<UserEntity?> getUser();
  Future<void> clearUser();

  /// Emits the current user on subscribe, `null` after clearUser/clearSession.
  Stream<UserEntity?> watchUser();

  Future<void> saveAuthSession(AuthSessionEntity session);
  Future<AuthSessionEntity?> getAuthSession();
  Future<void> clearAuthSession();

  Future<void> saveAccessToken(String token);
  Future<String?> getAccessToken();
  Future<void> clearAccessToken();

  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> clearRefreshToken();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });

  Future<void> saveSession({
    required UserEntity user,
    required String accessToken,
    required String refreshToken,
    AuthSessionEntity? session,
  });

  /// Clears user + both tokens + session and emits null on watchUser.
  Future<void> clearSession();
}
