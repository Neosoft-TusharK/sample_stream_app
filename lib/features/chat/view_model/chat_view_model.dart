import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_stream_app/core/models/chat_message.dart';
import '../../../core/services/socket_service.dart';

final chatViewModelProvider =
    StateNotifierProvider.autoDispose<ChatViewModel, List<Message>>((ref) {
      final socketService = ref.read(socketServiceProvider);
      return ChatViewModel(ref, socketService);
    });

class ChatViewModel extends StateNotifier<List<Message>> {
  final Ref ref;
  final SocketService _socketService;
  StreamSubscription<Message>? _messageSub;

  ChatViewModel(this.ref, this._socketService) : super([]);

  void connect(String userId) {
    _socketService.connect(userId);

    _messageSub?.cancel();
    _messageSub = _socketService.messageStream.listen((message) {
      if (userId != message.senderId) {
        state = [...state, message];
      } else {
        if (!state.contains(message)) state = [...state, message];
      }
    });
  }

  void sendMessage(String userId, String text) {
    _socketService.sendMessage(userId, text);
  }

  void disconnect() {
    _socketService.disconnect();
    _messageSub?.cancel();
    _socketService.dispose();
    _messageSub = null;
  }

  @override
  void dispose() {
    print("ChatViewModel disposed");
    _messageSub?.cancel();
    super
        .dispose(); // don't close the socketService stream — let Provider handle that
  }
}
