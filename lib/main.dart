import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_stream_app/core/theme/app_theme.dart';
import 'package:sample_stream_app/core/utils/notification/notification_helper.dart';
import 'package:sample_stream_app/app_initializer.dart'; // <-- import this

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(
    fileName: kDebugMode ? 'assets/.env.dev' : 'assets/.env.prod',
  );

  final container = ProviderContainer();
  final notificationHelper = container.read(notificationHelperProvider);
  await notificationHelper.initialize();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(theme: AppTheme.lightTheme, home: AppInitializer()),
    ),
  ); // <-- change here
}
