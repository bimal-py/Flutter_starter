import 'package:equatable/equatable.dart';

// Tokens live in secure storage; this entity holds session metadata only.
class AuthSessionEntity extends Equatable {
  const AuthSessionEntity({this.roles = const []});

  final List<String> roles;

  AuthSessionEntity copyWith({List<String>? roles}) =>
      AuthSessionEntity(roles: roles ?? this.roles);

  @override
  List<Object?> get props => [roles];
}
