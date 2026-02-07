import 'dart:async';
import 'dart:isolate';

import 'package:hw_ow/sensors/cpu.dart';
import 'package:hw_ow/sensors/mem.dart';

// This is the entry point for our background worker
void sensorWorker(SendPort sendPort) async {
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    try {

      final memInfo = await getMemoryUsage();

      final cpuInfo = await getCpuMetrics();
      // Send the data back as a Map
      sendPort.send({
       'memory': memInfo,
       'cpu': cpuInfo
      });
    } catch (e) {
      sendPort.send({'error': e.toString()});
    }
  });
}

