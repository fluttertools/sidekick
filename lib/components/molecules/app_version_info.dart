import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sidekick/utils/check_update.dart';
import 'package:sidekick/utils/manage_updates.dart';
import 'package:sidekick/version.dart';

class AppVersionInfo extends HookWidget {
  const AppVersionInfo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final latestRelease = useState<LatestVersion>();

    Future<void> setLatestVersion() async {
      final latest = await checkLatestRelease();
      latestRelease.value = latest;
    }

    useEffect(() {
      setLatestVersion();
      return;
    }, []);

    if (latestRelease == null) {
      return Container();
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
                  const Text(appVersion),
                  Text("${latestRelease.value.latestVersion}")
                ],
              ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          OutlinedButton.icon(
            onPressed: () {
              downloadRelease(latestRelease.value.latestVersion);
            },
            icon: const Icon(
              Icons.file_download,
              size: 18,
            ),
            label: Text(
              latestRelease.value.needUpdate ? "Install Now" : "Refresh",
            ),
          ),
        ],
      ),
    );
  }
}
