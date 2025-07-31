// file: lib/features/file_transfer/view/file_transfer_screen.dart

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_stream_app/core/utils/notification/file_transfer_notification.dart';
import 'package:sample_stream_app/features/file_transfer/view_model/file_transfer_view_model.dart';
import 'package:path_provider/path_provider.dart';

class FileTransferScreen extends ConsumerStatefulWidget {
  const FileTransferScreen({super.key});

  @override
  ConsumerState<FileTransferScreen> createState() => _FileTransferScreenState();
}

class _FileTransferScreenState extends ConsumerState<FileTransferScreen> {
  bool _isDownloading = false;
  String? _downloadedFilePath;
  Future<void> _downloadFile() async {
    final fileUrl =
        '${dotenv.env['BASE_URL']}/api/files/download/test_download.zip';

    late String savePath;

    if (Platform.isAndroid || Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      savePath = '${dir.path}/test_download.zip';
      _downloadedFilePath = savePath;
    } else {
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Downloaded File As',
        fileName: 'test_download.zip',
      );
      if (result == null) return;
      savePath = result;
      await File(savePath).parent.create(recursive: true);
    }

    setState(() => _isDownloading = true);

    try {
      await ref
          .read(fileTransferViewModelProvider.notifier)
          .downloadFile(fileUrl: fileUrl, savePath: savePath);

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Download Complete!')));
      }

      await ref
          .read(fileTransferNotificationProvider)
          .showComplete('Download Complete');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Download failed: $e')));
      }
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  Future<void> _deleteFile() async {
    if (_downloadedFilePath == null) return;

    final file = File(_downloadedFilePath!);
    if (await file.exists()) {
      await file.delete();

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('File deleted')));
        ref.read(fileTransferViewModelProvider.notifier).resetProgress();
      }

      _downloadedFilePath = null;
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('File not found')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(fileTransferViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('File Transfer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearProgressIndicator(
              value: progress.percent,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text('Download File'),
                  onPressed: _isDownloading ? null : _downloadFile,
                ),
                SizedBox(width: 15),
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete File'),
                  onPressed: (_downloadedFilePath != null && !_isDownloading)
                      ? _deleteFile
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
