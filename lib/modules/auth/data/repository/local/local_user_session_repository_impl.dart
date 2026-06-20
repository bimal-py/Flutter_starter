import 'dart:async';

import 'package:flutter_starter/core/utils/helpers/secure_storage_helper.dart';
import 'package:flutter_starter/modules/auth/data/mapper/auth_session_mapper.dart';
import 'package:flutter_starter/modules/auth/domain/entity/auth_session_entity.dart';
import 'package:flutter_starter/modules/auth/domain/repository/local/local_user_session_repository.dart';
import 'package:flutter_starter/modules/auth/utils/storage_helper/auth_hive.dart';
import 'package:flutter_starter/modules/auth/utils/storage_helper/auth_storage_keys.dart';
import 'package:flutter_starter/modules/user/user.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LocalUserSessionRepository)
class LocalUserSessionRepositoryImpl implements LocalUserSessionRepository {
  LocalUserSessionRepositoryImpl();

  late final _userBox = Hive.authBox;
  late final _secure = SecureStorageHelper.instance;

  final StreamController<UserEntity?> _controller =
      StreamController<UserEntity?>.broadcast();

  @override
  Future<void> saveUser(UserEntity user) async {
    await _userBox.put(
      AuthStorageKeys.loggedInUserKey,
      UserMapper.toRawJsonFromEntity(user),
    );
    _controller.add(user);
  }

  @override
  Future<UserEntity?> getUser() async {
    final raw = _userBox.get(AuthStorageKeys.loggedInUserKey);
    if (raw is! String || raw.isEmpty) return null;
    try {
      return UserMapper.fromRawJsonToEntity(raw);
    } catch (_) {
      await _userBox.delete(AuthStorageKeys.loggedInUserKey);
      return null;
    }
  }

  @override
  Future<void> clearUser() async {
    await _userBox.delete(AuthStorageKeys.loggedInUserKey);
    _controller.add(null);
  }

  @override
  Stream<UserEntity?> watchUser() async* {
    yield await getUser();
    yield* _controller.stream;
  }

  @override
  Future<void> saveAuthSession(AuthSessionEntity session) =>
      _userBox.put(
        AuthStorageKeys.authSessionKey,
        AuthSessionMapper.toRawJsonFromEntity(session),
      );

  @override
  Future<AuthSessionEntity?> getAuthSession() async {
    final raw = _userBox.get(AuthStorageKeys.authSessionKey);
    if (raw is! String || raw.isEmpty) return null;
    try {
      return AuthSessionMapper.fromRawJsonToEntity(raw);
    } catch (_) {
      await _userBox.delete(AuthStorageKeys.authSessionKey);
      return null;
    }
  }

  @override
  Future<void> clearAuthSession() =>
      _userBox.delete(AuthStorageKeys.authSessionKey);

  @override
  Future<void> saveAccessToken(String token) =>
      _secure.write(AuthStorageKeys.accessTokenKey, token);

  @override
  Future<String?> getAccessToken() =>
      _secure.read(AuthStorageKeys.accessTokenKey);

  @override
  Future<void> clearAccessToken() =>
      _secure.delete(AuthStorageKeys.accessTokenKey);

  @override
  Future<void> saveRefreshToken(String token) =>
      _secure.write(AuthStorageKeys.refreshTokenKey, token);

  @override
  Future<String?> getRefreshToken() =>
      _secure.read(AuthStorageKeys.refreshTokenKey);

  @override
  Future<void> clearRefreshToken() =>
      _secure.delete(AuthStorageKeys.refreshTokenKey);

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await saveAccessToken(accessToken);
    await saveRefreshToken(refreshToken);
  }

  @override
  Future<void> saveSession({
    required UserEntity user,
    required String accessToken,
    required String refreshToken,
    AuthSessionEntity? session,
  }) async {
    await saveTokens(accessToken: accessToken, refreshToken: refreshToken);
    if (session != null) await saveAuthSession(session);
    await saveUser(user);
  }

  @override
  Future<void> clearSession() async {
    await Future.wait([clearAccessToken(), clearRefreshToken()]);
    await clearAuthSession();
    await clearUser();
  }

  Future<void> dispose() => _controller.close();
}
