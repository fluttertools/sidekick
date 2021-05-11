import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../common/constants.dart';

final _platform = Platform.operatingSystem;

const _downloadBaseUrl = "$kGithubSidekickUrl/releases/download";

/// Download URL
String getDownloadReleaseUrl(String release) {
  return "$_downloadBaseUrl/$release/sidekick-$_platform-$release.$_platformExt";
}

/// File location for the download
Future<File> getDownloadFileLocation(String release) async {
  final downloadDir = await getDownloadsDirectory();
  final filePath = p.join(
    downloadDir.absolute.path,
    "sidekick-$release.$_platformExt",
  );
  return File(filePath);
}

String get _platformExt {
  switch (_platform) {
    case 'windows':
      {
        return 'msix';
      }
      break;
    case 'macos':
      {
        return 'dmg';
      }
      break;

    default:
      {
        return 'zip';
      }
      break;
  }
}
