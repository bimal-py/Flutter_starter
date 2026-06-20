part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.appLoadingState = AppLoadingState.initial,
    this.error,
  });

  final AppLoadingState appLoadingState;
  final String? error;

  LoginState copyWith({AppLoadingState? appLoadingState, String? error}) =>
      LoginState(
        appLoadingState: appLoadingState ?? this.appLoadingState,
        error: error,
      );

  @override
  List<Object?> get props => [appLoadingState, error];
}
