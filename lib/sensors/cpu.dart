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
    final parts = cpuLine.split(RegExp(r'\s+')).sublist(1);
    
    final int idle = int.parse(parts[3]);
    final int total = parts.map(int.parse).reduce((a, b) => a + b);

    final int totalDelta = total - _lastCpuStats[0];
    final int idleDelta = idle - _lastCpuStats[1];

    _lastCpuStats = [total, idle];

    if (totalDelta == 0) return 0.0;
    return (1.0 - (idleDelta / totalDelta)) * 100;
  } catch(err) {
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




