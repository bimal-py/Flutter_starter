part of 'third_party_auth_cubit.dart';

class ThirdPartyAuthState extends Equatable {
  const ThirdPartyAuthState({
    this.appLoadingState = AppLoadingState.initial,
    this.error,
  });

  final AppLoadingState appLoadingState;
  final String? error;

  ThirdPartyAuthState copyWith({
    AppLoadingState? appLoadingState,
    String? error,
  }) => ThirdPartyAuthState(
    appLoadingState: appLoadingState ?? this.appLoadingState,
    error: error,
  );

  @override
  List<Object?> get props => [appLoadingState, error];
}
