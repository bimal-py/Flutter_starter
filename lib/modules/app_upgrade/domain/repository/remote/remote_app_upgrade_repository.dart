import 'package:flutter_starter/modules/app_upgrade/domain/entity/app_upgrade_info_entity.dart';

abstract class RemoteAppUpgradeRepository {
  Future<AppUpgradeInfoEntity?> checkForUpdate();
  Future<void> markVersionIgnored(String version);
  String? getIgnoredVersion();
}
