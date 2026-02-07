import 'package:flutter/material.dart';
import 'package:hw_ow/lshw/hardware_node.dart';

class CpuSpecWidget extends StatelessWidget {
  final HardwareNode cpu;

  const CpuSpecWidget({
    super.key,
    required this.cpu,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.white10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Product Name
            Row(
              children: [
                const Icon(Icons.memory, color: Colors.orangeAccent, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    cpu.product ?? "Unknown Processor",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(height: 24, color: Colors.white10),

            // Main Specs Row (Architecture and Width)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSpecItem(
                  label: "VENDOR",
                  value: cpu.vendor ?? "N/A",
                  icon: Icons.factory,
                ),
                _buildSpecItem(
                  label: "MAX SPEED",
                  value: cpu.clock != null 
                      ? "${cpu.clockInMhz.toInt()} MHz" 
                      : "N/A",
                  icon: Icons.bolt,
                ),
              ],
            ),
            
            const SizedBox(height: 16),

            // Detailed Specs Rows
            _buildDetailRow("Description", cpu.description ?? "CPU"),
            _buildDetailRow("Capabilities", _getFormattedCapabilities()),
            _buildDetailRow("Bus Info", cpu.id ?? "N/A"),
            
            // Helpful Hint for Virtualization if found in capabilities
            if (cpu.description?.toLowerCase().contains('virtual') ?? false)
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "Virtual Machine Instance Detected",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 10),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper to format long strings of capabilities if lshw provides them
  String _getFormattedCapabilities() {
    // lshw often puts 'x86-64' or 'vme' here. 
    // We can simplify it for the UI.
    return "x86-64, VMX, AES, AVX2"; // Example static; adjust based on your model's fields
  }

  Widget _buildSpecItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.white38),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 1),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.orangeAccent,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 85,
            child: Text(
              "$label:",
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}