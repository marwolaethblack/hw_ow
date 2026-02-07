import 'package:flutter/material.dart';
import 'package:hw_ow/lshw/hardware_node.dart';

class MemoryStickWidget extends StatelessWidget {
  final HardwareNode stick;

  const MemoryStickWidget({
    super.key,
    required this.stick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E), // Deep dark theme
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
            // Header: Slot Name and Vendor
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.memory, color: Colors.cyanAccent, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      stick.slot ?? "Unknown Slot",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Text(
                  stick.vendor ?? "Generic",
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
            const Divider(height: 24, color: Colors.white10),

            // Main Specs Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSpecItem(
                  label: "CAPACITY",
                  value: "${stick.sizeInGb.toStringAsFixed(0)} GB",
                  icon: Icons.storage,
                ),
                _buildSpecItem(
                  label: "SPEED",
                  value: stick.clock != null 
                      ? "${stick.clockInMhz.toInt()} MHz" 
                      : "Unknown",
                  icon: Icons.speed,
                ),
              ],
            ),
            
            const SizedBox(height: 16),

            // Detailed Specs (Product/Description)
            _buildDetailRow("Product", stick.product ?? "N/A"),
            _buildDetailRow("Description", stick.description ?? "DIMM"),
            
            // If there's a serial number or ID available
            if (stick.id != null)
              _buildDetailRow("Hardware ID", stick.id!),
          ],
        ),
      ),
    );
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
            color: Colors.cyanAccent,
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
        children: [
          SizedBox(
            width: 80,
            child: Text(
              "$label:",
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}