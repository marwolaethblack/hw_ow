import 'dart:io';

import 'package:hw_ow/lshw/hardware_node.dart';
import 'package:hw_ow/lshw/hardware_parser.dart';

void main() {
  print("RUNNING MEMORY TEST");
  getPhysicalMemoryInfo().then((sticks) {
    print("STICKS");
    for (var stick in sticks) {
      print("AA ${stick.id} BB ${stick.product}");
    }
  });
}

Future<Map<String, String>> getMemoryUsage() async {
  final file = File('/proc/meminfo');
  final lines = await file.readAsLines();

  Map<String, String> stats = {};

  for (var line in lines) {
    // Each line looks like: "MemTotal:       16345000 kB"
    final parts = line.split(':');
    if (parts.length == 2) {
      final key = parts[0].trim();
      final value = parts[1].trim();
      stats[key] = value;
    }
  }
  return stats;
}

Future<List<HardwareNode>> getPhysicalMemoryInfo() async {
  final result = await Process.run('pkexec', ['lshw', '-json']);

  List<HardwareNode> allSticks = [];

  if (result.exitCode == 0) {
    final rootNodes = HardwareParser.parseLshw(result.stdout);

    // Usually lshw -C memory returns the memory nodes directly

    for (var node in rootNodes) {
      allSticks.addAll(HardwareParser.findAllMemorySticks(node));
    }
  }

  return allSticks;
}
