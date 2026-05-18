import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_starter/modules/notifications/domain/entity/notification_channels_entity.dart';
import 'package:flutter_starter/modules/notifications/domain/entity/notification_payload_entity.dart';
import 'package:flutter_starter/modules/notifications/domain/entity/notification_permission_status_entity.dart';
import 'package:flutter_starter/modules/notifications/domain/repository/local/notification_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FlutterLocalNotificationsProviderImpl implements NotificationProvider {
  FlutterLocalNotificationsProviderImpl();

  final _plugin = FlutterLocalNotificationsPlugin();
  final _tapController = StreamController<NotificationTapEventEntity>.broadcast();
  bool _initialized = false;

  @override
  bool get isInitialized => _initialized;

  @override
  Stream<NotificationTapEventEntity> get onTap => _tapController.stream;

  @override
  Future<void> initialize({
    List<NotificationChannelEntity> channels = const [],
    NotificationTapHandlerEntity? onLaunch,
  }) async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: _handleResponse,
    );

    if (Platform.isAndroid) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      for (final ch in [...NotificationChannelsEntity.defaults, ...channels]) {
        await android?.createNotificationChannel(_toAndroidChannel(ch));
      }
    }

    if (onLaunch != null) {
      final details = await _plugin.getNotificationAppLaunchDetails();
      final response = details?.notificationResponse;
      if (response != null) {
        final event = _decodeResponse(response);
        if (event != null) onLaunch(event);
      }
    }

    _initialized = true;
  }

  @override
  Future<void> show(NotificationPayloadEntity payload) async {
    await _plugin.show(
      payload.id,
      payload.title,
      payload.body,
      _platformDetails(payload),
      payload: jsonEncode({
        'data': payload.data,
        'channel': payload.channel,
        'title': payload.title,
        'body': payload.body,
        'id': payload.id,
      }),
    );
  }

  @override
  Future<void> schedule(NotificationPayloadEntity payload, DateTime when) async {
    await _plugin.zonedSchedule(
      payload.id,
      payload.title,
      payload.body,
      tz.TZDateTime.from(when, tz.local),
      _platformDetails(payload),
      payload: jsonEncode({
        'data': payload.data,
        'channel': payload.channel,
        'title': payload.title,
        'body': payload.body,
        'id': payload.id,
      }),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  Future<void> cancel(int id) => _plugin.cancel(id);

  @override
  Future<void> cancelAll() => _plugin.cancelAll();

  @override
  Future<NotificationPermissionStatusEntity> requestPermissions() async {
    if (Platform.isIOS) {
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      final granted =
          await ios?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
      return granted
          ? NotificationPermissionStatusEntity.granted
          : NotificationPermissionStatusEntity.denied;
    }
    if (Platform.isAndroid) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final granted = await android?.requestNotificationsPermission() ?? false;
      return granted
          ? NotificationPermissionStatusEntity.granted
          : NotificationPermissionStatusEntity.denied;
    }
    return NotificationPermissionStatusEntity.granted;
  }

  @override
  Future<NotificationPermissionStatusEntity> permissionStatus() async {
    if (Platform.isAndroid) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final enabled = await android?.areNotificationsEnabled() ?? false;
      return enabled
          ? NotificationPermissionStatusEntity.granted
          : NotificationPermissionStatusEntity.denied;
    }
    return NotificationPermissionStatusEntity.notDetermined;
  }

  NotificationDetails _platformDetails(NotificationPayloadEntity p) {
    final android = AndroidNotificationDetails(
      p.channel,
      p.channel,
      importance: _toAndroidImportance(p.priority),
      priority: _toAndroidPriority(p.priority),
      playSound: p.sound,
      actions: p.actions
          .map(
            (a) => AndroidNotificationAction(
              a.id,
              a.label,
              cancelNotification: !a.foreground,
            ),
          )
          .toList(),
    );
    final ios = DarwinNotificationDetails(
      presentSound: p.sound,
      categoryIdentifier: p.actions.isEmpty ? null : p.channel,
    );
    return NotificationDetails(android: android, iOS: ios);
  }

  AndroidNotificationChannel _toAndroidChannel(NotificationChannelEntity ch) =>
      AndroidNotificationChannel(
        ch.id,
        ch.name,
        description: ch.description,
        importance: _toAndroidImportance(ch.importance),
        playSound: ch.sound,
        showBadge: ch.showBadge,
      );

  Importance _toAndroidImportance(NotificationPriority p) => switch (p) {
    NotificationPriority.min => Importance.min,
    NotificationPriority.low => Importance.low,
    NotificationPriority.normal => Importance.defaultImportance,
    NotificationPriority.high => Importance.high,
    NotificationPriority.max => Importance.max,
  };

  Priority _toAndroidPriority(NotificationPriority p) => switch (p) {
    NotificationPriority.min => Priority.min,
    NotificationPriority.low => Priority.low,
    NotificationPriority.normal => Priority.defaultPriority,
    NotificationPriority.high => Priority.high,
    NotificationPriority.max => Priority.max,
  };

  void _handleResponse(NotificationResponse response) {
    final event = _decodeResponse(response);
    if (event != null) _tapController.add(event);
  }

  NotificationTapEventEntity? _decodeResponse(NotificationResponse response) {
    final raw = response.payload;
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final payload = NotificationPayloadEntity(
        id: decoded['id'] as int? ?? 0,
        title: decoded['title'] as String? ?? '',
        body: decoded['body'] as String? ?? '',
        data: Map<String, dynamic>.from(decoded['data'] as Map? ?? {}),
        channel:
            decoded['channel'] as String? ??
            NotificationChannelsEntity.defaultChannelId,
      );
      return NotificationTapEventEntity(
        payload: payload,
        actionId: response.actionId,
      );
    } catch (_) {
      return null;
    }
  }
}
