import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_stream_app/data/models/message_model.dart';
import 'package:sample_stream_app/data/models/network_state.dart';
import 'package:sample_stream_app/services/api_service.dart';
import 'package:sample_stream_app/services/network_service.dart';
import 'package:sample_stream_app/services/socket_service.dart';

final chatRepoProvider = Provider<ChatRepository>((ref) {
  final socketService = ref.watch(socketServiceProvider);
  final apiService = ref.watch(apiServiceProvider);
  final networkService = ref.watch(networkServiceProvider);
  final box = Hive.box<Message>('chat');
  return ChatRepository(socketService, box, apiService, networkService);
});

class ChatRepository {
  final NetworkState networkService;
  final SocketService socketService;
  final ApiService apiService;
  final Box<Message> box;

  ChatRepository(
    this.socketService,
    this.box,
    this.apiService,
    this.networkService,
  ) {
    socketService.messages.listen(_receive);
  }

  Future<void> init() async {
    final token = await apiService.login();
    socketService.connect(token);
    if (!socketService.isConnected) return;
    for (var msg in box.values.where((m) => !m.isSynced)) {
      await socketService.send(msg);
      msg.isSynced = true;
      await msg.save();
    }
  }

  Future<void> send(Message msg) async {
    await box.put(msg.id, msg);
    if (socketService.isConnected) {
      await socketService.send(msg);
      msg.isSynced = true;
      await msg.save();
    }
  }

  void _receive(Message msg) async {
    await box.put(msg.id, msg);
  }

  List<Message> getAll() => box.values.toList();
}
