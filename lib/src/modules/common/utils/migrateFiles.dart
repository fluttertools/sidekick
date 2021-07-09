import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final migrationName = 'hive_location_migration';

Future<void> checkMigration(Directory newPath) async {
  final prefs = await SharedPreferences.getInstance();
  final hasMigrated = prefs.getBool(migrationName);

  /// Return if has migrated
  if (hasMigrated == true) return;

  final oldPath = await getApplicationDocumentsDirectory();
  final files = [
    'settings_box.lock',
    'settings_box.hive',
    'projects_service_box.lock',
    'projects_service_box.hive'
  ];

  try {
    for (final fileName in files) {
      final file = File(p.join(oldPath.absolute.path, fileName));

      if (file.existsSync()) {
        file.copySync(p.join(newPath.absolute.path, fileName));
        file.deleteSync();
      }
    }
  } on Exception catch (err) {
    // Silent error
    print(err);
  }

  await prefs.setBool(migrationName, true);
}
