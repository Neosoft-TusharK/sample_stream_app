import 'package:flutter/material.dart';

class LayoutWrapper extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showAppBar;
  final List<Widget>? actions;

  const LayoutWrapper({
    super.key,
    required this.child,
    this.title,
    this.showAppBar = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(title: Text(title ?? ''), actions: actions)
          : null,
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(12.0), child: child),
      ),
    );
  }
}
