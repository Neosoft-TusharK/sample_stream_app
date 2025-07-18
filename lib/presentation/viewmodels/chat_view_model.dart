import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_stream_app/data/models/message_model.dart';
import 'package:sample_stream_app/data/repositories/chat_repository.dart';
import 'package:uuid/uuid.dart';

final chatVMProvider = StateNotifierProvider<ChatViewModel, List<Message>>((
  ref,
) {
  final repo = ref.watch(chatRepoProvider);
  final vm = ChatViewModel(repo);
  ref.onDispose(() {
    vm.dispose(); // ensures subscription is cleaned up
  });

  repo.init();
  return vm;
});

class ChatViewModel extends StateNotifier<List<Message>> {
  final ChatRepository repo;
  late final StreamSubscription<Message> _subscription;
  ChatViewModel(this.repo) : super(repo.getAll()) {
    _subscription = repo.socketService.messages.listen((msg) {
      state = [...state, msg];
    });
  }

  Future<void> send(String content, String userId) async {
    final m = Message(
      id: const Uuid().v4(),
      content: content,
      senderId: userId,
      timestamp: DateTime.now(),
    );
    state = [...state, m];
    await repo.send(m);
  }

  @override
  void dispose() {
    _subscription.cancel(); // important
    super.dispose();
  }
}
