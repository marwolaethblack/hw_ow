import 'package:flutter/material.dart';

class MemoryMonitor extends StatelessWidget {
  final Map<String, dynamic> data;

  const MemoryMonitor({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    try {
      if (!data.containsKey('memory')) {
        return const Text('Memory data not available');
      }

      final memData = data['memory'] as Map<String, dynamic>?;
      if (memData == null) {
        return const Text('Memory data is null');
      }

      final String? total = memData['MemTotal'];
      final String? available = memData['MemAvailable'];

      if (total == null || available == null) {
        return const Text('Missing MemTotal or MemAvailable');
      }

      final totalValue = int.parse(total.split(' ')[0]);
      final used = totalValue - int.parse(available.split(' ')[0]);
      final percent = (used / totalValue) * 100;

      return Column(
        children: [
          Text("RAM Usage: ${percent.toStringAsFixed(1)}%"),
          LinearProgressIndicator(value: percent / 100),
          Text("Used: ${(used / 1024 / 1024).toStringAsFixed(2)} GB"),
          Text("Total: ${(totalValue / 1024 / 1024).toStringAsFixed(2)} GB"),
        ],
      );
    } catch (e) {
      return Text('Error reading memory data: $e');
    }
  }
}
