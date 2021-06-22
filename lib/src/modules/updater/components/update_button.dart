import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/generated/l10n.dart';

import '../../../components/atoms/typography.dart';
import '../updater.provider.dart';

/// Sidekick update button
class SkUpdateButton extends HookWidget {
  /// Constructor
  const SkUpdateButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final updater = useProvider(updaterProvider.notifier);
    final updateInfo = useProvider(updaterProvider);

    /// Return empty if its not installed or does not need update
    if (!updateInfo.ready) {
      return SizedBox(height: 0, width: 0);
    }

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
              children: [
                Icon(MdiIcons.alertDecagram),
                SizedBox(width: 10),
                Heading(S.of(context).updateAvailable),
              ],
            ),
            content: Container(
              child: Paragraph(
                S.of(context).sidekickVersionUpdateinfolatestIsNowAvailable(updateInfo.latest),
              ),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(S.of(context).later),
              ),
              ElevatedButton(
                onPressed: () async {
                  await updater.openInstaller();
                  Navigator.of(context).pop();
                },
                child: Text(S.of(context).updateNow),
              ),
            ],
          );
        },
      );
    }

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ActionChip(
            onPressed: showUpdateDialog,
            label: Text(
              S.of(context).updateAvailable,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
