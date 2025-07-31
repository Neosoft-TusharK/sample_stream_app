// lib/core/utils/notification/file_transfer_notification.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'notification_helper.dart';

final fileTransferNotificationProvider = Provider<FileTransferNotification>(
  (ref) => FileTransferNotification(ref),
);

class FileTransferNotification {
  Ref ref;
  FileTransferNotification(this.ref);
  Future<void> showProgress({
    required String title,
    required int progress,
    required int maxProgress,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'file_transfer_progress_channel',
      'File Transfer Progress',
      channelDescription: 'Shows file download progress',
      importance: Importance.high,
      priority: Priority.high,
      onlyAlertOnce: true,
      showProgress: true,
      progress: progress,
      maxProgress: maxProgress,
      ongoing: true,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await ref
        .read(notificationHelperProvider)
        .plugin
        .show(
          2,
          title,
          'Downloading... $progress/$maxProgress',
          notificationDetails,
          payload: 'progress',
        );
  }

  Future<void> showComplete(String title) async {
    const androidDetails = AndroidNotificationDetails(
      'file_transfer_channel',
      'File Transfers',
      channelDescription: 'Notifies when file transfers complete',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await ref
        .read(notificationHelperProvider)
        .plugin
        .show(
          0,
          title,
          'Operation completed successfully',
          notificationDetails,
        );
  }

  Future<void> showError(String title) async {
    const androidDetails = AndroidNotificationDetails(
      'file_transfer_error_channel',
      'File Transfer Errors',
      channelDescription: 'Notifies when file transfers fail',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await ref
        .read(notificationHelperProvider)
        .plugin
        .show(
          1,
          title,
          'Something went wrong. Please try again.',
          notificationDetails,
        );
  }
}
