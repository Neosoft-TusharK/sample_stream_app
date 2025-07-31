import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/chat_message.dart';

final socketServiceProvider = Provider<SocketService>((ref) {
  final service = SocketService();

  // Clean up when the provider is destroyed (e.g., app closes)
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

class SocketService {
  IO.Socket? _socket;
  StreamController<Message>? _messageController =
      StreamController<Message>.broadcast();

  bool _isConnected = false;

  Stream<Message> get messageStream {
    _messageController ??= StreamController<Message>.broadcast();
    return _messageController!.stream;
  }

  void connect(String userId) {
    if (_isConnected) {
      print("⚠️ Already connected. Skipping new connection.");
      return;
    }

    print("🔌 Connecting socket for userId: $userId");

    _socket = IO.io(
      dotenv.env['SOCKET_URL'] ?? '',
      IO.OptionBuilder().setTransports(['websocket']).setQuery({
        'userId': userId,
      }).build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      _isConnected = true;
      print('✅ Socket connected: ${_socket!.id}');
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      print('❌ Socket disconnected');
    });

    _socket!.off('receiveMessage'); // Prevent duplicate listener
    _socket!.on('receiveMessage', (data) {
      final message = Message.fromJson(data);
      _messageController?.add(message);
    });
  }

  void sendMessage(String userId, String message) {
    print("Got to send message: $message");
    if (!_isConnected || _socket == null) {
      print("⚠️ Cannot send message. Socket is not connected.");
      return;
    }

    print("📤 Sending message: $message");
    _socket!.emit('sendMessage', {'userId': userId, 'message': message});
  }

  void disconnect() {
    if (_isConnected && _socket != null) {
      print("🔌 Disconnecting socket...");
      _socket!.disconnect();
      _isConnected = false;
    }
  }

  void dispose() {
    print("🧹 Disposing SocketService...");
    _socket?.dispose();
    _socket = null;
    _isConnected = false;

    _messageController?.close();
    print("${_messageController!.isClosed ? '✅' : '❌'} Message stream closed");
    _messageController = null;
  }
}
