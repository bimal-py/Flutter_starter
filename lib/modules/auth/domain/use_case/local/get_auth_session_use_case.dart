import 'dart:async';

import 'package:flutter_starter/common/common.dart';
import 'package:flutter_starter/modules/auth/domain/entity/auth_session_entity.dart';
import 'package:flutter_starter/modules/auth/domain/repository/local/local_user_session_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAuthSessionUseCase extends UseCase<AuthSessionEntity?, NoParams> {
  GetAuthSessionUseCase(this._store);

  final LocalUserSessionRepository _store;

  @override
  FutureOr<AuthSessionEntity?> execute(NoParams params) =>
      _store.getAuthSession();
}
