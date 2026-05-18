import 'package:flutter_starter/modules/notifications/domain/entity/notification_channels_entity.dart';
import 'package:flutter_starter/modules/notifications/domain/entity/notification_payload_entity.dart';
import 'package:flutter_starter/modules/notifications/domain/entity/notification_permission_status_entity.dart';

/// Plugin-agnostic notifications backend. The default app wires
/// [FlutterLocalNotificationsProviderImpl]; swap by implementing this interface
/// (e.g. AwesomeNotificationsProvider) and passing it to
/// `NotificationService.instance.initialize(provider: ...)`.
abstract class NotificationProvider {
  bool get isInitialized;

  Future<void> initialize({
    List<NotificationChannelEntity> channels = const [],
    NotificationTapHandlerEntity? onLaunch,
  });

  Future<void> show(NotificationPayloadEntity payload);
  Future<void> schedule(NotificationPayloadEntity payload, DateTime when);
  Future<void> cancel(int id);
  Future<void> cancelAll();

  Stream<NotificationTapEventEntity> get onTap;

  Future<NotificationPermissionStatusEntity> requestPermissions();
  Future<NotificationPermissionStatusEntity> permissionStatus();
}
