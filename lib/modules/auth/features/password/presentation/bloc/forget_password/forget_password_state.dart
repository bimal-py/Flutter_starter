part of 'forget_password_cubit.dart';

sealed class ForgetPasswordState extends Equatable {
  const ForgetPasswordState();

  @override
  List<Object?> get props => [];
}

final class ForgetPasswordInitial extends ForgetPasswordState {
  const ForgetPasswordInitial();
}

final class ForgetPasswordLoading extends ForgetPasswordState {
  const ForgetPasswordLoading();
}

final class ForgetPasswordSuccess extends ForgetPasswordState {
  const ForgetPasswordSuccess();
}

final class ForgetPasswordError extends ForgetPasswordState {
  const ForgetPasswordError({required this.error});
  final String error;

  @override
  List<Object?> get props => [error];
}
