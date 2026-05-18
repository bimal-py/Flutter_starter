import 'package:flutter_starter/modules/notifications/domain/entity/notification_channels_entity.dart';
import 'package:flutter_starter/modules/notifications/domain/entity/notification_payload_entity.dart';
import 'package:flutter_starter/modules/notifications/domain/entity/notification_permission_status_entity.dart';
import 'package:flutter_starter/modules/notifications/data/repository/local/flutter_local_notifications_provider_impl.dart';
import 'package:flutter_starter/modules/notifications/domain/repository/local/notification_provider.dart';

/// Public singleton consumers depend on. Delegates to a [NotificationProvider]
/// — default [FlutterLocalNotificationsProvider], swappable at init time.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  NotificationProvider? _provider;
  NotificationProvider get provider {
    final p = _provider;
    if (p == null) {
      throw StateError(
        'NotificationService.initialize() must be called before use.',
      );
    }
    return p;
  }

  bool get isInitialized => _provider?.isInitialized ?? false;

  Future<void> initialize({
    NotificationProvider? provider,
    List<NotificationChannelEntity> additionalChannels = const [],
    NotificationTapHandlerEntity? onLaunch,
  }) async {
    _provider = provider ?? FlutterLocalNotificationsProviderImpl();
    await _provider!.initialize(
      channels: additionalChannels,
      onLaunch: onLaunch,
    );
  }

  Future<void> show(NotificationPayloadEntity payload) => provider.show(payload);

  Future<void> schedule(NotificationPayloadEntity payload, DateTime when) =>
      provider.schedule(payload, when);

  Future<void> cancel(int id) => provider.cancel(id);

  Future<void> cancelAll() => provider.cancelAll();

  Stream<NotificationTapEventEntity> get onTap => provider.onTap;

  Future<NotificationPermissionStatusEntity> requestPermissions() =>
      provider.requestPermissions();

  Future<NotificationPermissionStatusEntity> permissionStatus() =>
      provider.permissionStatus();
}

