import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:hw_ow/hw_reader.dart';

class MemoryMonitor extends StatefulWidget {
  const MemoryMonitor({super.key});

  @override
  MemoryMonitorState createState() => MemoryMonitorState();
}

class MemoryMonitorState extends State<MemoryMonitor> {
  late ReceivePort _receivePort;
  late Stream<dynamic> _broadcastStream;

  @override
  void initState() {
    super.initState();
    _receivePort = ReceivePort();
    // Convert the ReceivePort into a broadcast stream for the UI
    _broadcastStream = _receivePort.asBroadcastStream();
    // Spawn the background worker
    Isolate.spawn(hardwareWorker, _receivePort.sendPort);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _broadcastStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        final data = snapshot.data as Map<String, dynamic>;

        final String total = data['memory']['MemTotal'];
        final String available = data['memory']['MemAvailable'];
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
      },
    );
  }
  
  @override
  void dispose() {
    _receivePort.close(); // Clean up the port
    super.dispose();
  }
}