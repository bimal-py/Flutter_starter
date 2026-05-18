import 'dart:async';

import 'package:flutter_starter/common/common.dart';
import 'package:flutter_starter/modules/app_upgrade/domain/entity/app_upgrade_info_entity.dart';
import 'package:flutter_starter/modules/app_upgrade/domain/repository/remote/app_upgrade_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CheckAppUpgradeUseCase extends UseCase<AppUpgradeInfoEntity?, NoParams> {
  CheckAppUpgradeUseCase(this._repository);

  final AppUpgradeRepository _repository;

  @override
  FutureOr<AppUpgradeInfoEntity?> execute(NoParams params) =>
      _repository.checkForUpdate();
}
