import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_stream_app/core/models/chat_message.dart';
import 'package:sample_stream_app/core/services/socket_service.dart';
import 'package:sample_stream_app/core/utils/notification/chat_notification.dart';

final chatNotificationNotifierProvider = Provider<ChatNotificationNotifier>((
  ref,
) {
  final service = ref.read(socketServiceProvider); // Your ChatService provider
  return ChatNotificationNotifier(service, ref);
});

class ChatNotificationNotifier {
  final Ref ref;
  String? _userId;
  final SocketService service;

  void injectUserId(String id) {
    _userId = id;
  }

  ChatNotificationNotifier(this.service, this.ref) {
    service.messageStream.listen((Message message) {
      if (_userId == null || _userId == message.senderId) return;
      ref.read(chatNotificationProvider).show(message); // Defined below
    });
  }
}
