import 'package:flutter/material.dart';

class CpuCoreGrid extends StatelessWidget {
  final List<double> cores;

  const CpuCoreGrid({super.key, required this.cores});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true, // Crucial for use inside a Column/ListView
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6, // 4 cores per row
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.5, // Keeps the boxes rectangular
      ),
      itemCount: cores.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white10),
          ),
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "CORE $index",
                style: const TextStyle(color: Colors.white38, fontSize: 8),
              ),
              Text(
                "${cores[index].toInt()} MHz",
                style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}