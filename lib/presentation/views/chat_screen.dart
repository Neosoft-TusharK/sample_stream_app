import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sample_stream_app/presentation/viewmodels/chat_view_model.dart';

class ChatScreen extends HookConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext c, WidgetRef ref) {
    final messages = ref.watch(chatVMProvider);
    final vm = ref.read(chatVMProvider.notifier);
    final ctrl = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Offline Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(messages[i].content),
                subtitle: Text(messages[i].isSynced ? '✔️' : '⌛'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(child: TextField(controller: ctrl)),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (ctrl.text.trim().isEmpty) return;
                    vm.send(ctrl.text.trim(), "user123");
                    ctrl.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
