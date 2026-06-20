import 'dart:async';

import 'package:flutter_starter/common/common.dart';
import 'package:flutter_starter/modules/auth/domain/repository/remote/auth_repository.dart';
import 'package:flutter_starter/modules/user/user.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetLoggedInUserUseCase extends UseCase<UserEntity?, NoParams> {
  GetLoggedInUserUseCase(this._repository);

  final AuthRepository _repository;

  @override
  FutureOr<UserEntity?> execute(NoParams params) =>
      _repository.getLoggedInUser();
}
