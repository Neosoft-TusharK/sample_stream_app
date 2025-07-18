class NetworkState {
  bool isConnected;

  NetworkState({this.isConnected = false});

  factory NetworkState.initial() {
    return NetworkState(isConnected: false);
  }

  @override
  String toString() {
    return 'NetworkState(isConnected: $isConnected)';
  }
}
