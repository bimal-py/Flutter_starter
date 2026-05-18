import 'package:flutter_starter/modules/app_upgrade/domain/entity/app_upgrade_info_entity.dart';
import 'package:flutter_starter/modules/app_upgrade/domain/repository/remote/app_upgrade_repository.dart';
import 'package:flutter_starter/modules/app_upgrade/utils/remote_config_helper.dart';
import 'package:flutter_starter/modules/app_upgrade/utils/remote_config_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AppUpgradeRepository)
class RemoteConfigUpgradeRepositoryImpl implements AppUpgradeRepository {
  RemoteConfigUpgradeRepositoryImpl({
    RemoteConfigService? service,
    RemoteConfigHelper? helper,
  })  : _service = service ?? RemoteConfigService.instance,
        _helper = helper ?? RemoteConfigHelper();

  final RemoteConfigService _service;
  final RemoteConfigHelper _helper;

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
