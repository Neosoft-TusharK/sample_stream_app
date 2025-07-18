import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sample_stream_app/core/theme/app_theme.dart';
import 'package:sample_stream_app/data/models/message_model.dart';
import 'presentation/views/chat_screen.dart';
import 'dart:io' as io;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(
    fileName: kReleaseMode ? 'assets/.env.prod' : 'assets/.env.dev',
  );
  await Hive.initFlutter();
  Hive.registerAdapter(MessageAdapter());
  final box = await Hive.openBox<Message>('chat');
  await box.clear();
  if (kDebugMode) {
    io.HttpClient.enableTimelineLogging = true;
  }
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext c) => MaterialApp(
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme, // Assuming dark theme is same for now
    debugShowCheckedModeBanner: false,
    title: 'Sample Stream App',
    themeMode: ThemeMode.system,
    home: ChatScreen(),
  );
}
