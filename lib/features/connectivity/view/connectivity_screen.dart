import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../connectivity/view_model/connectivity_view_model.dart';
import '../../connectivity/widgets/connectivity_snackbar.dart';

class ConnectivityScreen extends ConsumerWidget {
  const ConnectivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(connectivityViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Connectivity')),
      body: Stack(
        children: [
          const Center(
            child: Text(
              'Monitor internet connection\nand show snackbar with Retry',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
          if (!isConnected)
            ConnectivitySnackbar(
              onRetry: () {
                // Optional: trigger a refresh or recheck
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Retrying connection...')),
                );
              },
            ),
        ],
      ),
    );
  }
}
