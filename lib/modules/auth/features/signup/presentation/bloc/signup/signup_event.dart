part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class SignupSubmitted extends SignupEvent {
  const SignupSubmitted({
    required this.email,
    required this.password,
    required this.code,
  });

  final String email;
  final String password;
  final String code;

  @override
  List<Object?> get props => [email, password, code];
}
