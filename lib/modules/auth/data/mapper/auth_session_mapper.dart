import 'dart:convert';

import 'package:flutter_starter/modules/auth/data/model/auth_session_model.dart';
import 'package:flutter_starter/modules/auth/domain/entity/auth_session_entity.dart';

class AuthSessionMapper {
  AuthSessionMapper._();

  static AuthSessionEntity toEntity(AuthSessionModel model) =>
      AuthSessionEntity(roles: model.roles ?? const []);

  static AuthSessionModel toModel(AuthSessionEntity entity) =>
      AuthSessionModel(roles: entity.roles);

  static AuthSessionEntity fromJsonToEntity(Map<String, dynamic> json) =>
      toEntity(AuthSessionModel.fromJson(json));

  static AuthSessionEntity fromRawJsonToEntity(String rawJson) =>
      toEntity(
        AuthSessionModel.fromJson(
          jsonDecode(rawJson) as Map<String, dynamic>,
        ),
      );

  static Map<String, dynamic> toJsonFromEntity(AuthSessionEntity entity) =>
      toModel(entity).toJson();

  static String toRawJsonFromEntity(AuthSessionEntity entity) =>
      jsonEncode(toModel(entity).toJson());
}
