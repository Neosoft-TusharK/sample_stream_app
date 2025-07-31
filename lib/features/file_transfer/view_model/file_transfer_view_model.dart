import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_stream_app/core/services/file_transfer_service.dart';
import 'package:sample_stream_app/features/file_transfer/model/transfer_progress.dart';

final fileTransferViewModelProvider =
    StateNotifierProvider<FileTransferViewModel, TransferProgress>((ref) {
      return FileTransferViewModel(ref);
    });

class FileTransferViewModel extends StateNotifier<TransferProgress> {
  final Ref ref;
  StreamSubscription<TransferProgress>? _progressSub;

  FileTransferViewModel(this.ref) : super(TransferProgress.empty());

  void _handleProgress(TransferProgress progress) {
    state = progress;
  }

  void resetProgress() {
    state = TransferProgress.empty();
  }

  Future<void> downloadFile({
    required String fileUrl,
    required String savePath,
  }) async {
    // Cancel previous subscription if any
    await _progressSub?.cancel();

    // Start listening to progress before starting download
    final service = ref.read(fileTransferServiceProvider);
    _progressSub = service.progressStream.listen(_handleProgress);

    // Now start downloading
    await service.downloadFile(fileUrl: fileUrl, savePath: savePath);
  }

  @override
  void dispose() {
    _progressSub?.cancel();
    super.dispose();
  }
}
