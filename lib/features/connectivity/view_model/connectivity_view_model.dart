import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/connectivity_service.dart';

final connectivityViewModelProvider =
    StateNotifierProvider<ConnectivityViewModel, bool>((ref) {
      final service = ref.watch(connectivityServiceProvider);
      return ConnectivityViewModel(service);
    });

class ConnectivityViewModel extends StateNotifier<bool> {
  final ConnectivityService service;

  ConnectivityViewModel(this.service) : super(true) {
    service.connectivityStream.listen((isConnected) {
      state = isConnected;
    });
  }
}
