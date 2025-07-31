// lib/core/utils/notification/chat_notification.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_stream_app/core/services/socket_service.dart';
import 'package:sample_stream_app/core/services/user_id_service.dart';

import 'notification_helper.dart';
import 'package:sample_stream_app/core/models/chat_message.dart'
    as chat; // Adjust path to your Message model

// Adjust path to your Message model
final chatNotificationProvider = Provider<ChatNotification>(
  (ref) => ChatNotification(ref),
);

class ChatNotification {
  Ref ref;
  ChatNotification(this.ref);
  void show(chat.Message message) async {
    const androidDetails = AndroidNotificationDetails(
      'chat_channel',
      'Chat Messages',
      channelDescription: 'Chat notifications with reply support',
      importance: Importance.max,
      priority: Priority.high,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'reply',
          'Reply',
          inputs: [AndroidNotificationActionInput()],
          showsUserInterface: true,
        ),
      ],
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await ref
        .read(notificationHelperProvider)
        .plugin
        .show(
          message.hashCode,
          message.senderId,
          message.text,
          notificationDetails,
          payload: message.text, // Could be user ID
        );
  }

  void onNotificationAction(NotificationResponse response) async {
    print('Notification action received: ${response.actionId}');
    if (response.actionId == 'reply') {
      final replyText = response.input ?? '';
      final userId = await ref.read(userIdServiceProvider).getOrCreateUserId();
      ref.read(socketServiceProvider).sendMessage(userId, replyText);
      // ⬇️ You need to use your ChatService or SocketService to send this reply
      // Example:
      // ChatService.instance.sendMessage(replyText, receiverId);
    }
  }
}
