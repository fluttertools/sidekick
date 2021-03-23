import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

Future<void> openLink(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw '''Could not launch $url''';
  }
}

Future<void> openPath(String url) async {
  if (Platform.isWindows) {
    await Process.start('start', [url]);
  }

  if (Platform.isMacOS) {
    await Process.start('open', [url]);
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
