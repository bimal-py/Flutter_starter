import 'package:flutter_starter/modules/auth/data/model/auth_user_model.dart';
import 'package:flutter_starter/modules/auth/domain/entity/auth_user_entity.dart';
import 'package:injectable/injectable.dart';

/// Bridges the data-layer [AuthUserModel] (transport / persistence shape) to
/// the domain-layer [AuthUserEntity] (business shape). Repositories should
/// always go through this — never construct an entity from raw JSON directly.
@lazySingleton
class AuthUserMapper {
  const AuthUserMapper();

  AuthUserEntity toEntity(AuthUserModel model) => AuthUserEntity(
        id: model.id,
        email: model.email,
        displayName: model.displayName,
        photoUrl: model.photoUrl,
        phoneNumber: model.phoneNumber,
        isEmailVerified: model.isEmailVerified,
        isPhoneVerified: model.isPhoneVerified,
        extras: model.extras,
      );

  AuthUserModel toModel(AuthUserEntity entity) => AuthUserModel(
        id: entity.id,
        email: entity.email,
        displayName: entity.displayName,
        photoUrl: entity.photoUrl,
        phoneNumber: entity.phoneNumber,
        isEmailVerified: entity.isEmailVerified,
        isPhoneVerified: entity.isPhoneVerified,
        extras: entity.extras,
      );
}
