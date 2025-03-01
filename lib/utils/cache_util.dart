import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';

// Returns the cache size in bytes
Future<int> getCacheSize() async {
  final dirPath = (await getTemporaryDirectory()).path;
  final dir = io.Directory(dirPath);
  final dirList = dir.listSync(recursive: true, followLinks: false);

  int totalSize = 0;
  for (io.FileSystemEntity entity in dirList) {
    if (entity is io.File) {
      totalSize += entity.lengthSync();
    }
  }
  return totalSize;
}

Future<void> clearCache() async {
  final dirPath = (await getTemporaryDirectory()).path;
  final dir = io.Directory(dirPath);

  dir.deleteSync(recursive: true);
}
