import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_stream_app/features/file_transfer/model/transfer_progress.dart';

final fileTransferServiceProvider = Provider<FileTransferService>((ref) {
  final service = FileTransferService();

  // Auto-dispose the service's stream controller when provider is destroyed
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

class FileTransferService {
  final StreamController<TransferProgress> _progressController =
      StreamController<TransferProgress>.broadcast();

  Stream<TransferProgress> get progressStream => _progressController.stream;

  final Dio _dio = Dio();

  Future<void> downloadFile({
    required String fileUrl,
    required String savePath,
  }) async {
    await _dio.download(
      fileUrl,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          final progress = TransferProgress(
            sent: received,
            total: total,
            percent: received / total,
          );
          _progressController.add(progress);
        }
      },
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        receiveTimeout: const Duration(seconds: 60),
      ),
    );
  }

  void dispose() {
    _progressController.close();
  }
}
