import 'package:flutter/material.dart';
import 'package:sample_stream_app/presentaion/view/home_screen.dart';
import 'router/app_router.dart';

class MyApp extends StatelessWidget {
  final String currentUserId;
  const MyApp({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: AppRouter.generateRoute,
      home: HomeScreen(currentUserId: currentUserId), // <-- Pass here too
    );
  }
}
