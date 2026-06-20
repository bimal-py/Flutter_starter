import 'package:equatable/equatable.dart';
import 'package:flutter_starter/core/utils/extensions/string_extension.dart';

class UserEntity extends Equatable {
  const UserEntity({
    this.id,
    this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.profilePic,
    this.phoneVerified,
    this.emailVerified,
    this.role,
  });

  final int? id;
  final String? email;
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? profilePic;
  final bool? phoneVerified;
  final bool? emailVerified;
  final String? role;

  String? get fullName {
    final first = firstName?.capitalize;
    final last = lastName?.capitalize;
    final name = [first, last]
        .where((p) => p?.trim().isNotEmpty ?? false)
        .join(' ');
    return name.isEmpty ? email?.split('@').first.capitalize : name;
  }

  String? get shortName {
    final first = firstName?.capitalize;
    return (first == null || first.isEmpty)
        ? email?.split('@').first.capitalize
        : first;
  }

  UserEntity copyWith({
    int? id,
    String? email,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? profilePic,
    bool? phoneVerified,
    bool? emailVerified,
    String? role,
  }) => UserEntity(
    id: id ?? this.id,
    email: email ?? this.email,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    profilePic: profilePic ?? this.profilePic,
    phoneVerified: phoneVerified ?? this.phoneVerified,
    emailVerified: emailVerified ?? this.emailVerified,
    role: role ?? this.role,
  );

  @override
  List<Object?> get props => [
    id, email, phoneNumber, firstName, lastName,
    profilePic, phoneVerified, emailVerified, role,
  ];
}
