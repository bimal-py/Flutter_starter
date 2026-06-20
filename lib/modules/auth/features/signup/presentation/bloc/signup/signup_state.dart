part of 'signup_bloc.dart';

class SignupState extends Equatable {
  const SignupState({
    this.appLoadingState = AppLoadingState.initial,
    this.error,
  });

  final AppLoadingState appLoadingState;
  final String? error;

  SignupState copyWith({AppLoadingState? appLoadingState, String? error}) =>
      SignupState(
        appLoadingState: appLoadingState ?? this.appLoadingState,
        error: error,
      );

  @override
  List<Object?> get props => [appLoadingState, error];
}
