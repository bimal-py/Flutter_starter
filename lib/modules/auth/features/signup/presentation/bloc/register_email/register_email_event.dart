part of 'register_email_bloc.dart';

sealed class RegisterEmailEvent extends Equatable {
  const RegisterEmailEvent();

  @override
  List<Object?> get props => [];
}

class RegisterEmailSubmitted extends RegisterEmailEvent {
  const RegisterEmailSubmitted(this.email);
  final String email;

  @override
  List<Object?> get props => [email];
}

class RegisterEmailTermsToggled extends RegisterEmailEvent {
  const RegisterEmailTermsToggled(this.accepted);
  final bool accepted;

  @override
  List<Object?> get props => [accepted];
}
