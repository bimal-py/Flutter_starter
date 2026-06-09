import 'dart:async';

import 'package:flutter_starter/common/common.dart';
import 'package:flutter_starter/modules/device_info/domain/entity/device_info_entity.dart';
import 'package:flutter_starter/modules/device_info/domain/repository/remote/remote_device_info_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetDeviceInfoUseCase extends UseCase<DeviceInfoEntity, NoParams> {
  GetDeviceInfoUseCase(this._repository);

  final RemoteDeviceInfoRepository _repository;

  @override
  FutureOr<DeviceInfoEntity> execute(NoParams params) =>
      _repository.getDeviceInfo();
}
