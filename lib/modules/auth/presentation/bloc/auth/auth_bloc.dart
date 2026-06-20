import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/common/common.dart';
import 'package:flutter_starter/core/core.dart';
import 'package:flutter_starter/modules/auth/domain/entity/entity.dart';
import 'package:flutter_starter/modules/auth/domain/use_case/use_case.dart';
import 'package:flutter_starter/modules/user/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState.initial()) {
    on<_AuthInitialCheckRequested>(_onInitialCheck);
    on<_AuthUserChanged>(_onUserChanged);
    on<_AuthLogoutRequested>(_onLogout);

    add(const _AuthInitialCheckRequested());
    _subscription = _watchAuthUserUseCase
        .execute(const NoParams())
        .listen((user) => add(_AuthUserChanged(user)));
  }

  final GetLoggedInUserUseCase _getLoggedInUserUseCase =
      getIt<GetLoggedInUserUseCase>();
  final GetAuthSessionUseCase _getAuthSessionUseCase =
      getIt<GetAuthSessionUseCase>();
  final WatchAuthUserUseCase _watchAuthUserUseCase =
      getIt<WatchAuthUserUseCase>();
  final LogoutUseCase _logoutUseCase = getIt<LogoutUseCase>();

  StreamSubscription<UserEntity?>? _subscription;

  void logout({bool wasStillAuthenticated = true}) =>
      add(_AuthLogoutRequested(wasStillAuthenticated: wasStillAuthenticated));

  Future<void> _onInitialCheck(
    _AuthInitialCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = await _getLoggedInUserUseCase.execute(const NoParams());
    emit(await _resolve(user));
  }

  Future<void> _onUserChanged(
    _AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async => emit(await _resolve(event.user));

  Future<AuthState> _resolve(UserEntity? user) async {
    if (user == null) return const AuthState.unauthenticated();
    final session = await _getAuthSessionUseCase.execute(const NoParams());
    return AuthState.authenticated(user, session);
  }

  Future<void> _onLogout(
    _AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _logoutUseCase.execute(
        LogoutParams(wasStillAuthenticated: event.wasStillAuthenticated),
      );
    } catch (_) {
      // watchUser flips state once repo clears local data.
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
