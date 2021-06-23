import 'dart:io';

import 'package:sidekick/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openLink(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw S.current.couldNotLaunchUrl(url);
  }
}

Future<void> openPath(String url) async {
  if (Platform.isWindows) {
    await Process.start(S.current.start, [url]);
  }

  if (Platform.isMacOS) {
    await Process.start(S.current.open, [url]);
  }
}

Future<void> openVsCode(String url) async {
  final vsCodeUri = 'vscode://file/$url';
  return await openLink(vsCodeUri);
}

Future<void> openXcode(String url) async {
  final workspaceUri = '$url/ios/Runner.xcworkspace';
  return await openPath(workspaceUri);
}
