import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/chat_view_model.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String currentUserId;

  const ChatScreen({super.key, required this.currentUserId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late final ChatViewModel chatViewModel;
  @override
  void initState() {
    super.initState();
    chatViewModel = ref.read(chatViewModelProvider.notifier);
    chatViewModel.connect(widget.currentUserId);
  }

  @override
  void dispose() {
    chatViewModel.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Group Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                return MessageBubble(
                  message: message,
                  isMe: message.senderId == widget.currentUserId,
                );
              },
            ),
          ),
          MessageInput(
            onSend: (text) {
              ref
                  .read(chatViewModelProvider.notifier)
                  .sendMessage(
                    widget.currentUserId,
                    text,
                  ); // Removed receiverId
            },
          ),
        ],
      ),
    );
  }
}
