import 'dart:convert';

import 'package:flutter_starter/modules/user/data/model/user_model.dart';
import 'package:flutter_starter/modules/user/domain/entity/user_entity.dart';

class UserMapper {
  UserMapper._();

  static UserEntity toEntity(UserModel model) => UserEntity(
    id: model.id,
    email: model.email,
    phoneNumber: model.phoneNumber,
    firstName: model.firstName,
    lastName: model.lastName,
    profilePic: model.profilePic,
    phoneVerified: model.phoneVerified,
    emailVerified: model.emailVerified,
    role: model.role,
  );

  static UserModel toModel(UserEntity entity) => UserModel(
    id: entity.id,
    email: entity.email,
    phoneNumber: entity.phoneNumber,
    firstName: entity.firstName,
    lastName: entity.lastName,
    profilePic: entity.profilePic,
    phoneVerified: entity.phoneVerified,
    emailVerified: entity.emailVerified,
    role: entity.role,
  );

  static UserEntity fromJsonToEntity(Map<String, dynamic> json) =>
      toEntity(UserModel.fromJson(json));

  static UserEntity fromRawJsonToEntity(String rawJson) =>
      toEntity(UserModel.fromJson(jsonDecode(rawJson) as Map<String, dynamic>));

  static Map<String, dynamic> toJsonFromEntity(UserEntity entity) =>
      toModel(entity).toJson();

  static String toRawJsonFromEntity(UserEntity entity) =>
      jsonEncode(toModel(entity).toJson());
}
