import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:hw_ow/sensor_reader.dart';
import 'package:hw_ow/widgets/sensors/cpu/cpu.dart';
import 'package:hw_ow/widgets/sensors/memory.dart';

class Sensors extends StatefulWidget {
  const Sensors({super.key});


  @override
  SensorsState createState() => SensorsState();
}

class SensorsState extends State<Sensors> {
  late ReceivePort _receivePort;
  late Stream<dynamic> _broadcastStream;



  @override
  void initState() {
    super.initState();
    _receivePort = ReceivePort();
    // Convert the ReceivePort into a broadcast stream for the UI
    _broadcastStream = _receivePort.asBroadcastStream();
    // Spawn the background worker
    Isolate.spawn(sensorWorker, _receivePort.sendPort);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _broadcastStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        final data = snapshot.data as Map<String, dynamic>;

        return Column(
          children: [
            MemoryMonitor(data: data),
            CpuMonitorWidget(cpuData: data['cpu']),
          ],
        );
      },
    );
  }
  
  @override
  void dispose() {
    _receivePort.close(); // Clean up the port
    super.dispose();
  }
}