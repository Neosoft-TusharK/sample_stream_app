// lib/core/utils/notification/notification_helper.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_stream_app/core/utils/notification/chat_notification.dart';

final notificationHelperProvider = Provider<NotificationHelper>(
  (ref) => NotificationHelper(ref),
);

class NotificationHelper {
  Ref ref;
  NotificationHelper(this.ref);
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin get plugin => _plugin;

  Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: ref
          .read(chatNotificationProvider)
          .onNotificationAction,
    );

    // ✅ Request Android 13+ permissions
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }
}
