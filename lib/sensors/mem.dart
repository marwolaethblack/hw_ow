import 'dart:io';

void main() {
  print("RUNNING MEMORY TEST");
  getPhysicalMemoryInfo().then((sticks) {
    print("STICKS");
    for (var stick in sticks) {
      print("Size: ${stick['Size']}, Type: ${stick['Type']}, Speed: ${stick['Speed']}");
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

Future<List<Map<String, String>>> getPhysicalMemoryInfo() async {
  // Use -t 17 to filter for 'Memory Device' type only
  final result = await Process.run('sudo', ['dmidecode', '-t', '17']);
  
  if (result.exitCode != 0) return [];

  final List<Map<String, String>> sticks = [];
  final sections = result.stdout.toString().split('Memory Device');

  for (var section in sections) {
    if (!section.contains('Size:') || section.contains('No Module Installed')) continue;

    final Map<String, String> details = {};
    final lines = section.split('\n');

    for (var line in lines) {
      final parts = line.split(':');
      if (parts.length == 2) {
        final key = parts[0].trim();
        final value = parts[1].trim();
        details[key] = value;
      }
    }
    sticks.add(details);
  }
  return sticks;
}