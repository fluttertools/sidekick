import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../common/constants.dart';

final _platform = Platform.operatingSystem;

const _downloadBaseUrl = '$kGithubSidekickUrl/releases/download';

/// Download URL
String getDownloadReleaseUrl(String release) {
  return '$_downloadBaseUrl/$release/sidekick-$_platform-$release.$_platformExt';
}

/// Latest Sidekick release
String getLatestRelease(String release) {
  return '$_downloadBaseUrl/$release/sidekick-$_platform-$release.$_platformExt';
}

/// File location for the download
Future<File> getDownloadFileLocation(String release) async {
  final downloadDir = await getDownloadsDirectory();
  if (downloadDir == null) {
    throw Exception('Unable to get downloads directory');
  }
  final filePath = p.join(
    downloadDir.absolute.path,
    'sidekick-$release.$_platformExt',
  );
  return File(filePath);
}

String get _platformExt {
  switch (_platform) {
    case 'windows':
      {
        return 'msix';
      }

    case 'macos':
      {
        return 'dmg';
      }

    case 'linux':
      {
        return 'AppImage';
      }
    default:
      {
        return 'zip';
      }
  }
}
