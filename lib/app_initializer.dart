import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_stream_app/features/chat/notifier/chat_notification_notifier.dart';
import 'package:sample_stream_app/features/file_transfer/notifier/file_transfer_notifier.dart';
import 'core/services/user_id_service.dart';
import 'app.dart';

class AppInitializer extends ConsumerStatefulWidget {
  const AppInitializer({super.key});

  @override
  ConsumerState<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends ConsumerState<AppInitializer> {
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    ref.read(fileTransferNotifierProvider);
    ref.read(chatNotificationNotifierProvider);
  }

  Future<void> _loadUserId() async {
    final id = await ref.read(userIdServiceProvider).getOrCreateUserId();
    ref.read(chatNotificationNotifierProvider).injectUserId(id);
    setState(() => userId = id);
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return MyApp(currentUserId: userId!);
  }
}
