import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final migrationName = 'hive_location_migration';

Future<void> checkMigration(Directory newPath) async {
  final prefs = await SharedPreferences.getInstance();

  /// Return if has migrated
  if (prefs.getBool(migrationName)) return;

  final oldPath = await getApplicationDocumentsDirectory();
  final files = [
    'settings_box.lock',
    'settings_box.hive',
    'projects_service_box.lock',
    'projects_service_box.hive'
  ];

  for (final fileName in files) {
    final file = File(
      oldPath.absolute.path + Platform.pathSeparator + fileName,
    );
    if (file.existsSync()) {
      print('Legacy file found, starting migration...');
      file.copySync(
        newPath.absolute.path + Platform.pathSeparator + fileName,
      );
      file.deleteSync();
      print('Done');
    }
  }

  await prefs.setBool(migrationName, true);
}
