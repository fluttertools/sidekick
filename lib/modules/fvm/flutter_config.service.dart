import 'dart:io';

import 'package:fvm/fvm.dart';

import '../../utils/helpers.dart';

/// Flutter config service
class FlutterConfigService {
  FlutterConfigService._();

  /// Runs a simple Flutter cmd
  static Future<String> _runCmd(
    List<String> args,
  ) async {
    // Get exec path for flutter
    final globalVersion = await FVMClient.getGlobal();

    if (globalVersion == null) {
      // TODO: Need to change this
      // Can only run with a global version configured
      // Will cause settings to be all off
      return '';
    }

    final result = await Process.run(globalVersion.flutterExec, args);

    if (result.exitCode == 0) {
      return result.stdout as String;
    } else {
      return result.stderr as String;
    }
  }

  /// Sets Flutter config
  static Future<void> setFluterConfig(Map<String, bool> config) async {
    final analytics =
        config['analytics'] == true ? '--analytics' : '--no-analytics';
    final web = config['web'] == true ? '--enable-web' : '--no-enable-web';
    final macos = config['macos'] == true
        ? '--enable-macos-desktop'
        : '--no-enable-macos-desktop';
    final windows = config['windows'] == true
        ? '--enable-windows-desktop'
        : '--no-enable-windows-desktop';
    final linux = config['linux'] == true
        ? '--enable-linux-desktop'
        : '--no-enable-linux-desktop';

    await _runCmd([
      'config',
      analytics,
      macos,
      windows,
      linux,
      web,
    ]);
  }

  /// Returns configured Flutter settings
  static Future<Map<String, bool>> getFlutterConfig() async {
    final result = await _runCmd(['config']);
    final analytics = containsIgnoringWhitespace(
      result,
      'Analytics reporting is currently enabled',
    );
    final macos = containsIgnoringWhitespace(
      result,
      'enable-macos-desktop: true',
    );
    final windows = containsIgnoringWhitespace(
      result,
      'enable-windows-desktop: true',
    );
    final linux = containsIgnoringWhitespace(
      result,
      'enable-linux-desktop: true',
    );
    final web = containsIgnoringWhitespace(
      result,
      'enable-web: true',
    );

    return {
      'analytics': analytics,
      'macos': macos,
      'windows': windows,
      'linux': linux,
      'web': web,
    };
  }
}
