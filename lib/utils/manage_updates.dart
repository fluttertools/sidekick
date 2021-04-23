import 'dart:io';

//import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sidekick/constants.dart';
import 'package:sidekick/utils/notify.dart';
import 'package:sidekick/utils/open_link.dart';

final platform = Platform.operatingSystem;

const downloadBaseUrl = "$kGithubSidekickUrl/releases/download";

String getDownloadReleaseUrl(String release) {
  return "$downloadBaseUrl/$release/sidekick-$platform-$release.$platformExt";
}

Future<File> getFileLocation(String release) async {
  final downloadDir = await getDownloadsDirectory();
  final filePath = p.join(
    downloadDir.absolute.path,
    "sidekick-$release.$platformExt",
  );
  return File(filePath);
}

Future<void> downloadRelease(String release) async {
  final downloadUrl = getDownloadReleaseUrl(release);
  final file = await getFileLocation(release);

  if (!await file.exists()) {
    notify("Downloading...");
    var res = await http.get(Uri.parse(downloadUrl));
    if (res.statusCode == 200) {
      await file.writeAsBytes(res.bodyBytes);
      notify("Release downloaded! Opening...");
    } else {
      notifyError(
        "There was an issue downloading the file, plese try again later."
        "\nCode ${res.statusCode}",
      );
      return;
    }
  } else {
    notify("Opening update...");
  }
  openInstaller(file);
}

Future<void> openInstaller(File file) async {
  openLink("file://${file.absolute.path.replaceAll("\\", "/")}");
}

String get platformExt {
  switch (platform) {
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
