import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:hw_ow/hw_reader.dart';
import 'package:hw_ow/lshw/hardware_node.dart';
import 'package:hw_ow/sensors/mem.dart';
import 'package:hw_ow/widgets/cpu.dart';
import 'package:hw_ow/widgets/memory.dart';

class Sensors extends StatefulWidget {
  const Sensors({super.key});

  @override
  SensorsState createState() => SensorsState();
}

class SensorsState extends State<Sensors> {
  late ReceivePort _receivePort;
  late Stream<dynamic> _broadcastStream;
  late List<HardwareNode> _sticks;

  void loadRamData() async {
  final sticks = await getPhysicalMemoryInfo();
  
    setState(() {
      _sticks = sticks;
    });
} 

  @override
  void initState() {
    super.initState();
    _receivePort = ReceivePort();
    // Convert the ReceivePort into a broadcast stream for the UI
    _broadcastStream = _receivePort.asBroadcastStream();
    // Spawn the background worker
    Isolate.spawn(hardwareWorker, _receivePort.sendPort);
    _sticks = [];
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