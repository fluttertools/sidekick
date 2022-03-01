import 'dart:io';

import 'package:filesize/filesize.dart';

class DirectorySizeInfo {
  final int fileCount;
  final int totalSize;
  // final String friendlySize;
  DirectorySizeInfo({
    this.fileCount = 0,
    this.totalSize = 0,
    // this.friendlySize,
  });

  String get friendlySize {
    return filesize(totalSize);
  }
}

Future<DirectorySizeInfo> getDirectoriesSize(
    Iterable<Directory> directories) async {
  final futures = <Future<DirectorySizeInfo>>[];
  for (final directory in directories) {
    futures.add(getDirectorySize(directory));
  }

  final allSizes = await Future.wait(futures);

  if (allSizes.isEmpty) {
    return DirectorySizeInfo();
  }

  // Combine all the values
  final totalSize = allSizes.reduce((value, element) {
    return DirectorySizeInfo(
      fileCount: value.fileCount + element.fileCount,
      totalSize: value.totalSize + element.totalSize,
    );
  });

  return totalSize;
}

// TODO: Move this into fvm
Future<DirectorySizeInfo> getDirectorySize(Directory dir) async {
  var fileCount = 0;
  var totalSize = 0;

  try {
    if (await dir.exists()) {
      await dir.list(recursive: true, followLinks: false).forEach((entity) {
        if (entity is File) {
          fileCount++;
          totalSize += entity.lengthSync();
        }
      });
    }
  } on Exception catch (_) {
    //print(e.toString());
  }

  return DirectorySizeInfo(
    fileCount: fileCount,
    totalSize: totalSize,
  );
}
