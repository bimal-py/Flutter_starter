import 'package:flutter_starter/modules/package_info/domain/entity/package_info_entity.dart';

abstract class RemotePackageInfoRepository {
  Future<PackageInfoEntity> getPackageInfo();
}
