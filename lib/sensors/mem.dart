import 'dart:io';



void main() async {
  final memInfo = await getMemoryStats();
  print(memInfo.memTotal);
  print('Total RAM: ${memInfo.memTotal} kB');
  print('Available RAM: ${memInfo.memAvailable} kB');
}

Future<MemoryStats> getMemoryStats() async {
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
  return MemoryStats(stats);
}

class MemoryStats {
  final Map<String, String> raw;
  
  MemoryStats(this.raw);
  
  int _parseValue(String key) {
    final value = raw[key];
    if (value == null) throw Exception('Key $key not found');
    return int.parse(value.replaceAll(RegExp(r'\s+kB$'), ''));
  }
  
  int get memTotal => _parseValue('MemTotal');
  int get memFree => _parseValue('MemFree');
  int get memAvailable => _parseValue('MemAvailable');
  int get buffers => _parseValue('Buffers');
  int get cached => _parseValue('Cached');
  int get swapCached => _parseValue('SwapCached');
  int get active => _parseValue('Active');
  int get inactive => _parseValue('Inactive');
  int get activeAnon => _parseValue('Active(anon)');
  int get inactiveAnon => _parseValue('Inactive(anon)');
  int get activeFile => _parseValue('Active(file)');
  int get inactiveFile => _parseValue('Inactive(file)');
  int get unevictable => _parseValue('Unevictable');
  int get mlocked => _parseValue('Mlocked');
  int get swapTotal => _parseValue('SwapTotal');
  int get swapFree => _parseValue('SwapFree');
  int get zswap => _parseValue('Zswap');
  int get zswapped => _parseValue('Zswapped');
  int get dirty => _parseValue('Dirty');
  int get writeback => _parseValue('Writeback');
  int get anonPages => _parseValue('AnonPages');
  int get mapped => _parseValue('Mapped');
  int get shmem => _parseValue('Shmem');
  int get kReclaimable => _parseValue('KReclaimable');
  int get slab => _parseValue('Slab');
  int get sReclaimable => _parseValue('SReclaimable');
  int get sUnreclaim => _parseValue('SUnreclaim');
  int get kernelStack => _parseValue('KernelStack');
  int get pageTables => _parseValue('PageTables');
  int get secPageTables => _parseValue('SecPageTables');
  int get nfsUnstable => _parseValue('NFS_Unstable');
  int get bounce => _parseValue('Bounce');
  int get writebackTmp => _parseValue('WritebackTmp');
  int get commitLimit => _parseValue('CommitLimit');
  int get committedAs => _parseValue('Committed_AS');
  int get vmallocTotal => _parseValue('VmallocTotal');
  int get vmallocUsed => _parseValue('VmallocUsed');
  int get vmallocChunk => _parseValue('VmallocChunk');
  int get percpu => _parseValue('Percpu');
  int get hardwareCorrupted => _parseValue('HardwareCorrupted');
  int get anonHugePages => _parseValue('AnonHugePages');
  int get shmemHugePages => _parseValue('ShmemHugePages');
  int get shmemPmdMapped => _parseValue('ShmemPmdMapped');
  int get fileHugePages => _parseValue('FileHugePages');
  int get filePmdMapped => _parseValue('FilePmdMapped');
  int get cmaTotal => _parseValue('CmaTotal');
  int get cmaFree => _parseValue('CmaFree');
  int get unaccepted => _parseValue('Unaccepted');
  int get balloon => _parseValue('Balloon');
  int get hugePagesTotal => _parseValue('HugePages_Total');
  int get hugePagesFree => _parseValue('HugePages_Free');
  int get hugePagesRsvd => _parseValue('HugePages_Rsvd');
  int get hugePagesSurp => _parseValue('HugePages_Surp');
  int get hugepagesize => _parseValue('Hugepagesize');
  int get hugetlb => _parseValue('Hugetlb');
  int get directMap4k => _parseValue('DirectMap4k');
  int get directMap2M => _parseValue('DirectMap2M');
}