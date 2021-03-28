import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sidekick/utils/manage_updates.dart';
import 'package:sidekick/version.dart';
import 'package:version/version.dart';

class AppVersionInfo extends StatefulWidget {
  const AppVersionInfo({Key key}) : super(key: key);

  @override
  _AppVersionInfoState createState() => _AppVersionInfoState();
}

class _AppVersionInfoState extends State<AppVersionInfo> {
  Version latestversion;
  Version installedVersion;
  bool isNewerAvailable = false;

  @override
  Widget build(BuildContext context) {
    if (latestversion == null) updateGithubLatestVersion();
    if (installedVersion == null) {
      try {
        installedVersion = Version.parse(appVersion);
      } on FormatException catch (_) {
        installedVersion = Version(0, 0, 1);
      }
    }
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Installed Version:"),
                  Text("Latest Version:"),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$installedVersion",
                  ),
                  Text("${latestversion ?? "Unknown"}")
                ],
              ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          OutlinedButton.icon(
            onPressed: updateGithubLatestVersion,
            icon: const Icon(
              Icons.file_download,
              size: 18,
            ),
            label: Text(
              isNewerAvailable ? "Install Now" : "Refresh",
            ),
          ),
        ],
      ),
    );
  }

  void updateGithubLatestVersion() {
    if (isNewerAvailable) {
      downloadRelease(latestversion.toString());
    } else {
      GitHub(auth: Authentication.anonymous())
          .repositories
          .getLatestRelease(
            RepositorySlug("leoafarias", "sidekick"),
          )
          .then(
        (value) {
          setState(() {
            latestversion = Version.parse(value.tagName);
            isNewerAvailable = (latestversion > installedVersion);
          });
        },
      ).catchError((e) {
        showToast(
          "Error getting latest GitHub release",
          position: ToastPosition.bottom,
        );
      });
    }
  }
}
