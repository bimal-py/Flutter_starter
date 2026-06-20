import 'dart:async';

import 'package:flutter_starter/core/errors/exceptions.dart';
import 'package:flutter_starter/core/network/dio/interceptors/logout_interceptor.dart';
import 'package:flutter_starter/core/network/service/remote_service.dart';
import 'package:flutter_starter/modules/auth/auth.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class RemoteAuthRepositoryImpl implements AuthRepository {
  RemoteAuthRepositoryImpl(
    this._remote,
    this._store,
    this._thirdParty,
    this._logoutHandler,
    this._logoutInterceptor,
  );

  final RemoteService _remote;
  final LocalUserSessionRepository _store;
  final ThirdPartyAuthProvider _thirdParty;
  final LogoutHandler _logoutHandler;
  final LogoutInterceptor _logoutInterceptor;

  @override
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _logoutInterceptor.clearLoggedOut();
    try {
      final response = await _remote.post(
        endpoint: AuthApiRoute.login,
        body: {'username': email, 'password': password},
      );
      await _persistSession(response);
      await _fetchAndSaveUser();
    } catch (_) {
      await _store.clearSession();
      rethrow;
    }
  }

  @override
  Future<void> loginWithGoogle() =>
      _exchangeThirdParty(_thirdParty.retrieveGoogleCredential());

  @override
  Future<void> loginWithApple() =>
      _exchangeThirdParty(_thirdParty.retrieveAppleCredential());

  Future<void> _exchangeThirdParty(
    Future<ThirdPartyCredential> retrieve,
  ) async {
    _logoutInterceptor.clearLoggedOut();
    try {
      final cred = await retrieve;
      final isGoogle = cred.provider == ThirdPartyProvider.google;
      final response = await _remote.post(
        endpoint: isGoogle ? AuthApiRoute.googleLogin : AuthApiRoute.appleLogin,
        body: isGoogle
            ? {
                'access_token': cred.token,
                'provider': 'google',
              }
            : {
                'state': cred.state,
                'code': cred.token,
                'is_iphone': cred.isFromIos,
              },
      );
      await _persistSession(response);
      await _fetchAndSaveUser();
    } catch (_) {
      await _thirdParty.signOut();
      await _store.clearSession();
      rethrow;
    }
  }

  // Backend returns tokens in three known shapes:
  //   1. top-level {access_token, refresh_token, roles}
  //   2. envelope {data: {access_token, refresh_token, ...}}
  //   3. nested tokens {data: {tokens: {access, refresh}, ...}}
  Future<void> _persistSession(dynamic response) async {
    if (response is! Map<String, dynamic>) {
      throw const AuthenticationException(
        message: AuthError.invalidAuthResponse,
      );
    }
    final accessToken = _extractToken(response, const ['access_token', 'access']);
    final refreshToken = _extractToken(response, const ['refresh_token', 'refresh']);
    if (accessToken == null || refreshToken == null) {
      throw const AuthenticationException(message: AuthError.missingTokens);
    }
    await _store.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    final sessionRoot = _sessionRoot(response);
    await _store.saveAuthSession(
      AuthSessionMapper.fromJsonToEntity(sessionRoot),
    );
  }

  String? _extractToken(Map<String, dynamic> body, List<String> keys) {
    String? pick(Map source) {
      for (final key in keys) {
        final value = source[key];
        if (value is String && value.isNotEmpty) return value;
      }
      return null;
    }

    return pick(body) ??
        (body['data'] is Map
            ? (pick(body['data'] as Map) ??
                  (body['data']['tokens'] is Map
                      ? pick(body['data']['tokens'] as Map)
                      : null))
            : null);
  }

  Map<String, dynamic> _sessionRoot(Map<String, dynamic> body) {
    if (body.containsKey('roles')) return body;
    final data = body['data'];
    if (data is Map<String, dynamic>) return data;
    return body;
  }

  Future<void> _fetchAndSaveUser() async {
    final response = await _remote.get(
      endpoint: AuthApiRoute.user,
      authRequired: true,
    );
    final data = response is Map<String, dynamic>
        ? (response['data'] ?? response)
        : null;
    if (data is! Map<String, dynamic> || data.isEmpty) {
      await _store.clearSession();
      throw const AuthenticationException(message: AuthError.userFetchFailed);
    }
    await _store.saveUser(UserMapper.fromJsonToEntity(data));
  }

  @override
  Future<void> registerEmail({required String email}) async {
    final response = await _remote.post(
      endpoint: AuthApiRoute.registerEmail,
      body: {'email': email},
    );
    if (response is Map<String, dynamic> && response['status'] == false) {
      throw const AuthenticationException(
        message: AuthError.registerEmailFailed,
      );
    }
  }

  @override
  Future<void> registerUser({
    required String email,
    required String password,
    required String code,
  }) async {
    _logoutInterceptor.clearLoggedOut();
    try {
      final response = await _remote.post(
        endpoint: AuthApiRoute.register,
        body: {'email': email, 'code': code, 'password': password},
      );
      if (response is Map<String, dynamic> && response['status'] == false) {
        throw const AuthenticationException(message: AuthError.registerFailed);
      }
      await _persistSession(response);
      await _fetchAndSaveUser();
    } catch (_) {
      await _store.clearSession();
      rethrow;
    }
  }

  @override
  Future<void> forgetPassword({required String email}) async {
    await _remote.post(
      endpoint: AuthApiRoute.forgetPassword,
      body: {'email': email},
    );
  }

  @override
  Future<void> resetPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await _remote.post(
      endpoint: AuthApiRoute.resetPassword,
      authRequired: true,
      body: {
        'old_password': oldPassword,
        'new_password1': newPassword,
        'new_password2': newPassword,
      },
    );
  }

  @override
  Future<UserEntity?> getLoggedInUser() => _store.getUser();

  @override
  Stream<UserEntity?> watchUser() => _store.watchUser();

  @override
  Future<void> logout({bool wasStillAuthenticated = true}) =>
      _logoutHandler.logout(wasStillAuthenticated: wasStillAuthenticated);
}
