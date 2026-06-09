import 'package:flutter_starter/modules/app_upgrade/domain/entity/app_upgrade_info_entity.dart';
import 'package:flutter_starter/modules/app_upgrade/domain/repository/remote/remote_app_upgrade_repository.dart';
import 'package:flutter_starter/modules/app_upgrade/utils/helper/remote_config_helper.dart';
import 'package:flutter_starter/modules/app_upgrade/utils/helper/remote_config_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: RemoteAppUpgradeRepository)
class RemoteAppUpgradeRepositoryImpl implements RemoteAppUpgradeRepository {
  final RemoteConfigService _service = RemoteConfigService.instance;
  final RemoteConfigHelper _helper = RemoteConfigHelper();

  @override
  Future<AppUpgradeInfoEntity?> checkForUpdate() async {
    await _service.init();
    if (!_service.isInitialized) return null;
    final latestVersion = _service.latestReleasedVersion;
    if (latestVersion.isEmpty || latestVersion == '0.0.0') return null;
    final currentVersion = await _helper.currentAppVersion();
    return AppUpgradeInfoEntity(
      latestVersion: latestVersion,
      currentVersion: currentVersion,
      isForceUpdate: _service.forceUpdate,
      updateMessage: _service.updateMessage,
    );
  }

  @override
  Future<void> markVersionIgnored(String version) =>
      _helper.markVersionIgnored(version);

  @override
  String? getIgnoredVersion() => _helper.readIgnoredVersion();
}
