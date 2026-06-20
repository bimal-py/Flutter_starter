import 'package:flutter_starter/common/common.dart';
import 'package:flutter_starter/modules/auth/domain/repository/remote/auth_repository.dart';
import 'package:flutter_starter/modules/user/user.dart';
import 'package:injectable/injectable.dart';

@injectable
class WatchAuthUserUseCase extends StreamUseCase<UserEntity?, NoParams> {
  WatchAuthUserUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Stream<UserEntity?> execute(NoParams params) => _repository.watchUser();
}
