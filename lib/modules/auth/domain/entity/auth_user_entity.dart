import 'package:equatable/equatable.dart';

/// Backend-agnostic user shape. Anything app-specific (roles, claims, etc.)
/// goes in [extras] so the contract stays stable across REST / Firebase /
/// Supabase / custom JWT implementations.
///
/// Pure domain object: no serialization. JSON conversion lives on
/// `AuthUserModel` in the data layer; `AuthUserMapper` bridges the two.
class AuthUserEntity extends Equatable {
  const AuthUserEntity({
    required this.id,
    this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.extras = const {},
  });

  /// Opaque, provider-stable identifier. Don't assume it's numeric.
  final String id;

  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final bool isEmailVerified;
  final bool isPhoneVerified;

  /// Backend-specific payload. Must be JSON-serialisable for round-trip.
  final Map<String, dynamic> extras;

  AuthUserEntity copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    Map<String, dynamic>? extras,
  }) => AuthUserEntity(
    id: id ?? this.id,
    email: email ?? this.email,
    displayName: displayName ?? this.displayName,
    photoUrl: photoUrl ?? this.photoUrl,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
    extras: extras ?? this.extras,
  );

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    photoUrl,
    phoneNumber,
    isEmailVerified,
    isPhoneVerified,
    extras,
  ];
}
