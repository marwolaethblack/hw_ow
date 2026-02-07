import 'dart:convert';

import 'package:hw_ow/lshw/hardware_node.dart';

class HardwareParser {
  static List<HardwareNode> parseLshw(String jsonString) {
    final decoded = jsonDecode(jsonString);

    // lshw sometimes returns a single Map, sometimes a List
    if (decoded is List) {
      return decoded.map((item) => HardwareNode.fromJson(item)).toList();
    } else {
      return [HardwareNode.fromJson(decoded)];
    }
  }

  /// Specifically finds all RAM sticks within the hardware tree
  static List<HardwareNode> findAllMemorySticks(HardwareNode root) {
    List<HardwareNode> sticks = [];

    // Memory sticks usually have the class 'memory' and a 'slot' defined
    if (root.classType == 'memory' &&
        root.slot != null &&
        root.size != null &&
        root.id!.contains("bank")) {
      sticks.add(root);
    }

    // Recurse through children
    if (root.children != null) {
      for (var child in root.children!) {
        sticks.addAll(findAllMemorySticks(child));
      }
    }

    return sticks;
  }
}
