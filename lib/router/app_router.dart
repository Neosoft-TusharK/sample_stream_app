import 'package:flutter/material.dart';
import 'package:sample_stream_app/router/routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeBuilder = AppRoutes.routes[settings.name];
    if (routeBuilder != null) {
      return MaterialPageRoute(
        builder: (context) => routeBuilder(context, settings.arguments),
        settings: settings,
      );
    }
    return MaterialPageRoute(
      builder: (_) =>
          const Scaffold(body: Center(child: Text('Route not found'))),
    );
  }
}
