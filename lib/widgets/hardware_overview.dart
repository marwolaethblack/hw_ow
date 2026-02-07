import 'package:flutter/material.dart';
import 'package:hw_ow/lshw/hardware-load.dart';
import 'package:hw_ow/lshw/hardware_node.dart';
import 'package:hw_ow/lshw/hardware_parser.dart';
import 'package:hw_ow/widgets/overview/cpu.dart';
import 'package:hw_ow/widgets/overview/memory.dart';

class HardwareOverview extends StatefulWidget {
  const HardwareOverview({super.key});

  @override
  State<HardwareOverview> createState() => _HardwareOverviewState();
}

class _HardwareOverviewState extends State<HardwareOverview> {
  List<HardwareNode> _memorySticks = [];
  HardwareNode? _cpu = null;

  @override
  void initState() {
    super.initState();
    _loadHardware();
  }

  Future<void> _loadHardware() async {
    final nodes = await loadHardwareInfo();

    List<HardwareNode> allSticks = [];

      HardwareNode? firstCpu;
    

    for (var node in nodes) {
      allSticks.addAll(HardwareParser.findAllMemorySticks(node));
      HardwareNode? cpu = HardwareParser.findCpus(node).firstOrNull;
      if (cpu != null && firstCpu == null) {
        firstCpu = cpu;
      }
    }

    if (mounted) {
      setState(() {
        _memorySticks = allSticks;
        _cpu = firstCpu;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            for (final stick in _memorySticks) MemoryStickWidget(stick: stick),
            if (_cpu != null) CpuSpecWidget(cpu: _cpu!),
          ],
        ),
      ),
    );
  }
}
