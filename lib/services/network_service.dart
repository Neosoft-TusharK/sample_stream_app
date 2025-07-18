import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_stream_app/data/models/network_state.dart';

final networkServiceProvider =
    StateNotifierProvider<NetworkService, NetworkState>(
      (ref) => NetworkService(),
    );

class NetworkService extends StateNotifier<NetworkState> {
  NetworkService() : super(NetworkState.initial());

  void updateConnectionStatus(bool isConnected) {
    state = NetworkState(isConnected: isConnected);
  }
}
