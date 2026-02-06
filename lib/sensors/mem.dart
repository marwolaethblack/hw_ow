import 'dart:io';



Future<Map<String, String>> getMemoryStats() async {
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