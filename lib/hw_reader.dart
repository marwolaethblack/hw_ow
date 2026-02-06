import 'dart:async';
import 'dart:isolate';

import 'package:hw_ow/sensors/mem.dart';

// This is the entry point for our background worker
void hardwareWorker(SendPort sendPort) async {
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    try {

      final memInfo = await getMemoryUsage();

      // Send the data back as a Map
      sendPort.send({
       'memory': memInfo
      });
    } catch (e) {
      sendPort.send({'error': e.toString()});
    }
  });
}

