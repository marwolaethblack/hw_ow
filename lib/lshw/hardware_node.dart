import 'dart:convert';

class HardwareNode {
  final String? id;
  final String? classType;
  final String? description;
  final String? product;
  final String? vendor;
  final String? slot;
  final int? size;
  final int? clock;
  final int? capacity;
  final List<HardwareNode>? children;

  HardwareNode({
    this.id,
    this.classType,
    this.description,
    this.product,
    this.vendor,
    this.slot,
    this.size,
    this.clock,
    this.capacity,
    this.children,
  });

  factory HardwareNode.fromJson(Map<String, dynamic> json) {
    return HardwareNode(
      id: json['id'],
      classType: json['class'],
      description: json['description'],
      product: json['product'],
      vendor: json['vendor'],
      slot: json['slot'],
      size: json['size'],
      clock: json['clock'],
      capacity: json['capacity'],
      // Recursively parse children if they exist
      children: json['children'] != null
          ? (json['children'] as List)
                .map((child) => HardwareNode.fromJson(child))
                .toList()
          : null,
    );
  }

  // Helper to convert bytes to GB for the UI
  double get sizeInGb => (size ?? 0) / (1024 * 1024 * 1024);

  // Update these getters in your HardwareNode class
  double get clockInMhz {
    // Use capacity if it exists and is higher than clock (standard for CPUs)
    final rawValue = (capacity != null && capacity! > (clock ?? 0))
        ? capacity
        : (clock ?? 0);

    // lshw usually returns Hz, so divide by 1,000,000 to get MHz
    return rawValue! / 1000000;
  }

  double get clockInGhz => clockInMhz / 1000;
}
