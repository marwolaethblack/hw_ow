import 'package:flutter/material.dart';
import 'package:hw_ow/widgets/cpu_core_grid.dart';

class CpuMonitorWidget extends StatelessWidget {
  final Map<String, dynamic> cpuData;

  const CpuMonitorWidget({super.key, required this.cpuData});

  // Helper to determine color based on temperature severity
  Color _getTempColor(double temp) {
    if (temp > 80) return Colors.redAccent;
    if (temp > 65) return Colors.orangeAccent;
    return Colors.greenAccent;
  }

  // Helper to determine color based on load severity
  Color _getLoadColor(double load) {
    if (load > 90) return Colors.redAccent;
    if (load > 70) return Colors.orangeAccent;
    return Colors.blueAccent;
  }

  @override
  Widget build(BuildContext context) {
    // Extract values with null-safety fallbacks
    final double load = (cpuData['load'] ?? 0.0);
    final double temp = (cpuData['temp'] ?? 0.0);
    final List<double> cores = List<double>.from(cpuData['cores'] ?? []);

    return Card(
      color: Colors.grey[900],
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "PROCESSOR",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Load Section
                _buildMetricColumn(
                  label: "LOAD",
                  value: "${load.toStringAsFixed(1)}%",
                  valueColor: _getLoadColor(load),
                  icon: Icons.speed,
                ),
                // Vertical Divider
                Container(height: 40, width: 1, color: Colors.white10),
                // Temp Section
                _buildMetricColumn(
                  label: "TEMP",
                  value: "${temp.toStringAsFixed(1)}°C",
                  valueColor: _getTempColor(temp),
                  icon: Icons.thermostat,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white10),
            const SizedBox(height: 8),

            const Text(
              "CORE FREQUENCIES",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Add the Grid here
            CpuCoreGrid(cores: cores),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricColumn({
    required String label,
    required String value,
    required Color valueColor,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.white38),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white38, fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            fontFamily:
                'monospace', // Monospaced keeps the text from jumping around
          ),
        ),
      ],
    );
  }
}
