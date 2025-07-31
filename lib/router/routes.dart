import 'package:flutter/material.dart';
import '../features/chat/view/chat_screen.dart';
import '../features/file_transfer/view/file_transfer_screen.dart';
import '../features/connectivity/view/connectivity_screen.dart';

class AppRoutes {
  static const String chat = '/chat';
  static const String fileTransfer = '/file';
  static const String connectivity = '/connectivity';

  static final routes = <String, Widget Function(BuildContext, Object?)>{
    connectivity: (context, _) => const ConnectivityScreen(),
    fileTransfer: (context, _) => const FileTransferScreen(),
    chat: (context, args) {
      final userId = args as String;
      return ChatScreen(currentUserId: userId);
    },
  };
}
