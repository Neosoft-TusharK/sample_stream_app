import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_stream_app/data/models/message_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final socketServiceProvider = Provider<SocketService>((ref) => SocketService());

class SocketService {
  late IO.Socket _socket;
  final _msgs = StreamController<Message>.broadcast();

  Stream<Message> get messages => _msgs.stream;

  void connect(String token) {
    _socket = IO.io(
      dotenv.get('SOCKET_URL'),
      IO.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .setExtraHeaders({'Authorization': 'Bearer $token'}) // optional
          .build(),
    );

    _socket.on('message', (data) {
      _msgs.add(Message.fromJson(data));
    });
    _socket.onError((error) {
      print('Socket error: $error');
    });
    _socket.onConnectError((error) {
      print('Socket connect error: $error');
    });
    _socket.onConnect((_) => print('Socket connected'));
    _socket.onDisconnect((_) => print('Socket disconnected'));
  }

  bool get isConnected => _socket.connected;

  Future<void> send(Message msg) async {
    _socket.emit('message', msg.toJson());
  }
}
