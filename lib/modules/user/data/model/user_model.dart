import 'dart:convert';

class UserModel {
  UserModel({
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

  UserModel copyWith({
    int? id,
    String? email,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? profilePic,
    bool? phoneVerified,
    bool? emailVerified,
    String? role,
  }) => UserModel(
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

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
    email: json['email'] as String?,
    phoneNumber: json['phone_number'] as String?,
    firstName: json['first_name'] as String?,
    lastName: json['last_name'] as String?,
    profilePic: json['profile_pic'] as String?,
    phoneVerified: json['phone_verified'] as bool?,
    emailVerified: json['email_verified'] as bool?,
    role: json['role'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'phone_number': phoneNumber,
    'first_name': firstName,
    'last_name': lastName,
    'profile_pic': profilePic,
    'phone_verified': phoneVerified,
    'email_verified': emailVerified,
    'role': role,
  };
}
