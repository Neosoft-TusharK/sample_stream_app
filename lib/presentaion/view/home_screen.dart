import 'package:flutter/material.dart';
import 'package:sample_stream_app/features/canvas/view/canvas_app.dart';
import '../widgets/bottom_nav.dart';
import '../../features/connectivity/view/connectivity_screen.dart';
import '../../features/file_transfer/view/file_transfer_screen.dart';
import '../../features/chat/view/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;
  const HomeScreen({super.key, required this.currentUserId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      const CanvasApp(),
      const ConnectivityScreen(),
      const FileTransferScreen(),
      ChatScreen(currentUserId: widget.currentUserId), // ✅ pass userId here
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
