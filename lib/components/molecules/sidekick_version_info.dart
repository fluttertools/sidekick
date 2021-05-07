import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../modules/updater/check_update.dart';
import '../../utils/manage_updates.dart';
import '../../version.dart';

/// Sidekick version info
class SidekickVersionInfo extends HookWidget {
  /// Constructor
  const SidekickVersionInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final latestRelease = useState<SidekickUpdateInfo>(null);

    Future<void> setLatestVersion() async {
      final latest = await checkLatestRelease();
      latestRelease.value = latest;
    }

    useEffect(() {
      setLatestVersion();
      return;
    }, []);

    if (latestRelease.value == null) {
      return const SizedBox(height: 0, width: 0);
    }

    final hasUpdate = latestRelease.value.needUpdate;
    final latestVersion = latestRelease.value.latestVersion;

    if (hasUpdate) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('A new version of Sidekick is available ($latestVersion).'),
          const SizedBox(width: 5),
          TextButton(
            child: const Text('Click here to download.'),
            onPressed: () {},
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 5),
        const Text(appVersion),
        const SizedBox(width: 20),
        Text("${latestRelease.value.latestVersion}"),
        const SizedBox(width: 20),
        OutlinedButton.icon(
          icon: Icon(hasUpdate ? Icons.file_download : Icons.refresh),
          label: Text(hasUpdate ? "Install Now" : "Refresh"),
          onPressed: () {
            if (hasUpdate) {
              downloadRelease(latestRelease.value.latestVersion);
            } else {
              setLatestVersion();
            }
          },
        ),
      ],
    );
  }
}
