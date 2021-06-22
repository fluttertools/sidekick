import 'dart:io';

void migrateFiles(Directory oldPath, List<String> files, Directory newPath) {
  files.forEach((fileName) {
    final file =
        File(oldPath.absolute.path + Platform.pathSeparator + fileName);
    if (file.existsSync()) {
      print('Legacy file found, starting migration...');
      file.copySync(newPath.absolute.path + Platform.pathSeparator + fileName);
      file.deleteSync();
      print('Done');
    }
  });
}
