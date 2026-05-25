import 'package:flutter_starter/modules/device_info/domain/entity/device_info_entity.dart';

abstract class DeviceInfoRepository {
  Future<DeviceInfoEntity> getDeviceInfo();
}
