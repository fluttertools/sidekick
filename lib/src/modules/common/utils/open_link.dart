import 'dart:io';
import 'package:url_launcher/url_launcher_string.dart';

import 'which.dart';

Future<void> openLink(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw "Error";
  }
}

Future<void> openPath(String url) async {
  if (Platform.isWindows) {
    await Process.start('start', [url]);
  } else if (Platform.isMacOS) {
    await Process.start('open', [url]);
  } else if (Platform.isLinux) {
    await Process.start('xdg-open', [url]);
  }
}

Future<void> openVsCode(
  String path, {
  String? customLocation,
}) async {
  if (Platform.isWindows || Platform.isLinux) {
    await Process.run('code', [path], runInShell: true);
  } else {
    // Check if VSCode is installed on path, it it is open the file, otherwise open the url.
    final vscode = await which('code');
    if (vscode != null) {
      await Process.run('code', [path], runInShell: true);
    } else {
      final vsCodeUri = 'vscode://file/$path';
      return await openLink(vsCodeUri);
    }
  }
}

Future<void> openXcode(
  String path, {
  String? customLocation,
}) async {
  final workspaceUri = '$path/ios/Runner.xcworkspace';
  return await openPath(workspaceUri);
}

Future<void> openCustom(
  String path, {
  String? customLocation,
}) async {
  if (customLocation == null) {
    return await openPath(path);
  }
  if (Platform.isMacOS) {
    await Process.run(
      "open",
      ['-a ${customLocation.trim()}', path],
      runInShell: true,
    );
  } else {
    await Process.run(
      customLocation,
      [path],
      runInShell: true,
    );
  }
}
