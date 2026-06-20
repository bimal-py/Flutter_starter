part of 'register_email_bloc.dart';

class RegisterEmailState extends Equatable {
  const RegisterEmailState({
    this.appLoadingState = AppLoadingState.initial,
    this.isAcceptedTerms = false,
    this.error,
  });

  final AppLoadingState appLoadingState;
  final bool isAcceptedTerms;
  final String? error;

  RegisterEmailState copyWith({
    AppLoadingState? appLoadingState,
    bool? isAcceptedTerms,
    String? error,
  }) => RegisterEmailState(
    appLoadingState: appLoadingState ?? this.appLoadingState,
    isAcceptedTerms: isAcceptedTerms ?? this.isAcceptedTerms,
    error: error,
  );

  @override
  List<Object?> get props => [appLoadingState, isAcceptedTerms, error];
}
