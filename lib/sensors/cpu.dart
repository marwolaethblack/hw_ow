import 'dart:io';

Future<Map<String, dynamic>> getCpuMetrics() async {
  return {
    'load': await getCpuLoad(),
    'temp': await readPackageTemp(),
    'cores': await getCoreSpeeds(),
  };
}

Future<List<double>> getCoreSpeeds() async {
  final content = await File('/proc/cpuinfo').readAsString();
  final regExp = RegExp(r'cpu MHz\s+:\s+(\d+\.\d+)');
  final matches = regExp.allMatches(content);

  return matches.map((m) => double.parse(m.group(1)!)).toList();
}

// Variables to persist between Timer ticks for CPU Load calculation
List<int> _lastCpuStats = [0, 0]; // [Total, Idle]

Future<double> getCpuLoad() async {
  try {
    final stats = await File('/proc/stat').readAsLines();
    final cpuLine = stats.firstWhere((l) => l.startsWith('cpu '));
    final parts = cpuLine
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();

    // Column indices (starts at 1 because index 0 is 'cpu')
    // 1:user, 2:nice, 3:system, 4:idle, 5:iowait, 6:irq, 7:softirq, 8:steal
    final int idle = int.parse(parts[4]);
    final int iowait = int.parse(parts[5]);

    final int idleTotal = idle + iowait;

    // Total is the sum of every numeric column
    final int total = parts.sublist(1).map(int.parse).reduce((a, b) => a + b);

    final int totalDelta = total - _lastCpuStats[0];
    final int idleDelta = idleTotal - _lastCpuStats[1];

    _lastCpuStats = [total, idleTotal];

    if (totalDelta <= 0) return 0.0;

    // The percentage of time NOT spent in idle/iowait
    double usage = (totalDelta - idleDelta) / totalDelta;

    // Clamp between 0.0 and 1.0, then return as percentage
    return (usage.clamp(0.0, 1.0)) * 100;
  } catch (_) {
    return 0.0;
  }
}

Future<double> readPackageTemp() async {
  try {
    final dir = Directory('/sys/class/hwmon/');
    final hwmons = await dir.list().toList();
    for (var hwmon in hwmons) {
      final name = await File('${hwmon.path}/name').readAsString();
      if (name.contains('coretemp') || name.contains('k10temp')) {
        final raw = await File('${hwmon.path}/temp1_input').readAsString();
        return int.parse(raw.trim()) / 1000.0;
      }
    }
  } catch (_) {}
  return 0.0;
}


Future<int> getProcessorCount() async {
  final lines = await File('/proc/stat').readAsLines();
  // Filter for 'cpu0', 'cpu1', etc.
  return lines.where((l) => RegExp(r'^cpu\d+').hasMatch(l)).length;
}