import 'dart:convert';

class AuthSessionModel {
  AuthSessionModel({this.roles});

  final List<String>? roles;

  AuthSessionModel copyWith({List<String>? roles}) =>
      AuthSessionModel(roles: roles ?? this.roles);

  factory AuthSessionModel.fromRawJson(String str) =>
      AuthSessionModel.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) =>
      AuthSessionModel(
        roles: json['roles'] == null
            ? []
            : List<String>.from(
                (json['roles'] as List).map((x) => x.toString()),
              ),
      );

  Map<String, dynamic> toJson() => {
    'roles': roles == null ? [] : List<dynamic>.from(roles!),
  };
}
