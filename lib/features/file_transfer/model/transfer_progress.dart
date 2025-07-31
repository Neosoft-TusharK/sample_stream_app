class TransferProgress {
  final int sent;
  final int total;
  final double percent;

  const TransferProgress({
    required this.sent,
    required this.total,
    required this.percent,
  });

  factory TransferProgress.empty() =>
      const TransferProgress(sent: 0, total: 0, percent: 0);
}
