import 'package:dio/dio.dart';
import 'package:flutter_starter/core/network/dio/config/dio_config.dart';
import 'package:flutter_starter/core/network/dio/interceptors/logout_interceptor.dart';
import 'package:flutter_starter/core/network/service/cancel_token_manager.dart';
import 'package:flutter_starter/modules/auth/auth.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LogoutHandler)
class LogoutHandlerImpl implements LogoutHandler {
  LogoutHandlerImpl(
    this._store,
    this._thirdParty,
    this._dioConfig,
    this._logoutInterceptor,
  );

  final LocalUserSessionRepository _store;
  final ThirdPartyAuthProvider _thirdParty;
  final DioConfig _dioConfig;
  final LogoutInterceptor _logoutInterceptor;

  @override
  Future<void> logout({bool wasStillAuthenticated = true}) async {
    if (wasStillAuthenticated) {
      try {
        await _logoutFromServer();
      } catch (_) {
        // Local teardown must proceed even if remote calls fail.
      }
    }
    try {
      await _thirdParty.signOut();
    } catch (_) {}
    GlobalCancelTokenManager.cancelAllRequests('logout');
    _logoutInterceptor.markAsLoggedOut();
    await _store.clearSession();
  }

  // Fresh Dio with no interceptors — a 401 here must not re-enter the refresh flow.
  Future<void> _logoutFromServer() async {
    final accessToken = await _store.getAccessToken() ?? '';
    final refreshToken = await _store.getRefreshToken() ?? '';
    if (accessToken.isEmpty || refreshToken.isEmpty) return;

    final dio = Dio(
      BaseOptions(
        baseUrl: _dioConfig.baseUrl,
        connectTimeout: _dioConfig.connectionTimeout,
        receiveTimeout: _dioConfig.receiveTimeout,
      ),
    );
    await dio.post(
      '${_dioConfig.baseUrl}/${AuthApiRoute.logout}',
      data: {'refresh': refreshToken},
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }
}
