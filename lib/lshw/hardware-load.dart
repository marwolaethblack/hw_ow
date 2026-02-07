import 'dart:io';

import 'package:hw_ow/lshw/hardware_node.dart';
import 'package:hw_ow/lshw/hardware_parser.dart';

Future<List<HardwareNode>> loadHardwareInfo() async {
  final result = await Process.run('pkexec', ['lshw', '-json']);
  if (result.exitCode == 0) {
    final rootNodes = HardwareParser.parseLshw(result.stdout);
    return rootNodes;
  } else {
    print('Error running lshw: ${result.stderr}');
    return [];
  }
}