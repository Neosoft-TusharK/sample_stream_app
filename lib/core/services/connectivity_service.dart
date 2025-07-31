import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});

class ConnectivityService {
  final _controller = StreamController<bool>.broadcast();

  ConnectivityService() {
    InternetConnection().onStatusChange.listen((InternetStatus result) {
      _controller.add(result == InternetStatus.connected);
    });
    InternetConnection().onStatusChange.listen((InternetStatus result) {
      _controller.add(result == InternetStatus.connected);
    });
  }

  Stream<bool> get connectivityStream => _controller.stream;

  void dispose() {
    _controller.close();
  }
}
