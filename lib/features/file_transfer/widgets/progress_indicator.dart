import 'package:flutter/material.dart';

class TransferProgressIndicator extends StatelessWidget {
  final int value;
  final String label;

  const TransferProgressIndicator({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: LinearProgressIndicator(value: value / 100),
        ),
        Text('$value%'),
      ],
    );
  }
}
