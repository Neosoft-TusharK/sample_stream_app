import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_stream_app/core/utils/notification/file_transfer_notification.dart';
import 'package:sample_stream_app/core/services/file_transfer_service.dart';
import 'package:sample_stream_app/features/file_transfer/model/transfer_progress.dart';

final fileTransferNotifierProvider = Provider<FileTransferNotifier>((ref) {
  final notifier = FileTransferNotifier(ref);
  ref.onDispose(() => notifier.dispose());
  return notifier;
});

class FileTransferNotifier {
  final Ref ref;
  late final StreamSubscription<TransferProgress> _sub;

  FileTransferNotifier(this.ref) {
    _sub = ref.read(fileTransferServiceProvider).progressStream.listen((
      progress,
    ) {
      ref
          .read(fileTransferNotificationProvider)
          .showProgress(
            title: 'Downloading file',
            progress: progress.sent,
            maxProgress: progress.total,
          );
    });
  }

  void dispose() {
    _sub.cancel();
  }
}
