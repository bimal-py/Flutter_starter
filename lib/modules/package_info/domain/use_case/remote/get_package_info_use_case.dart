import 'dart:async';

import 'package:flutter_starter/common/common.dart';
import 'package:flutter_starter/modules/package_info/domain/entity/package_info_entity.dart';
import 'package:flutter_starter/modules/package_info/domain/repository/remote/remote_package_info_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPackageInfoUseCase extends UseCase<PackageInfoEntity, NoParams> {
  GetPackageInfoUseCase(this._repository);

  final RemotePackageInfoRepository _repository;

  @override
  FutureOr<PackageInfoEntity> execute(NoParams params) =>
      _repository.getPackageInfo();
}
