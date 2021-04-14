import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/utils/check_update.dart';
import 'package:sidekick/utils/manage_updates.dart';

class UpdateAvailableButton extends HookWidget {
  const UpdateAvailableButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final latest = useState<LatestVersion>(null);
    final needUpdate = useState(false);
    // Check latest release on mount
    void checkUpdate() async {
      latest.value = await checkLatestRelease();
      needUpdate.value = latest.value.needUpdate;
    }

    useEffect(() {
      checkUpdate();
      return;
    }, []);

    void showUpdateDialog() {
      // flutter defined function
      showDialog(
        context: context,
        builder: (context) {
          // return object of type Dialog
          return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            buttonPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            title: Row(
              children: const [
                Icon(MdiIcons.alertDecagram),
                SizedBox(width: 10),
                Heading("Update available."),
              ],
            ),
            content: Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Paragraph(
                    "Current ${latest.value.currentVersion}\n"
                    "New ${latest.value.latestVersion}",
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                child: const Text("Later"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text("Update Now"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  downloadRelease(latest.value.latestVersion);
                },
              ),
            ],
          );
        },
      );
    }

    if (needUpdate.value) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ActionChip(
              onPressed: showUpdateDialog,
              label: const Text(
                'Update Available',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
