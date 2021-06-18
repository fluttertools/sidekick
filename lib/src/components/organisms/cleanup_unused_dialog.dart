import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sidekick/generated/l10n.dart';

import '../../modules/common/utils/notify.dart';
import '../../modules/fvm/fvm.provider.dart';
import '../../modules/fvm/fvm_queue.provider.dart';

Future<void> cleanupUnusedDialog(BuildContext context) async {
  final unusedVersions = context.read(unusedVersionProvider);

  if (unusedVersions.isEmpty) {
    notify(S.of(context).noUnusedFlutterSdkVersionsInstalled);
    return;
  }

  await showDialog(
    context: context,
    builder: (context) {
      var selected = <String, bool>{};
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(S.of(context).cleanUpUnusedVersions),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(S.of(context).cancel),
              ),
              TextButton(
                onPressed: () async {
                  final unusedSelected = unusedVersions.where(
                    (element) => selected.containsKey(element.name),
                  );
                  for (final version in unusedSelected) {
                    context.read(fvmQueueProvider.notifier).remove(version);
                  }

                  Navigator.of(context).pop();
                },
                child: Text(S.of(context).confirm),
              ),
            ],
            content: Container(
              constraints: const BoxConstraints(maxWidth: 350, maxHeight: 300),
              child: CupertinoScrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                    Text(
                        S.of(context).theseVersionAreNotPinnedToAProject +
                        S.of(context).doYouWantToRemoveThemToFreeUpSpace,
                      ),
                      const SizedBox(height: 10),
                      ...ListTile.divideTiles(
                        context: context,
                        color: Theme.of(context).dividerColor,
                        tiles: [
                          ...unusedVersions.map((version) {
                            return CheckboxListTile(
                              title: Text(version.name),
                              dense: true,
                              value: selected[version.name] ?? false,
                              onChanged: (value) {
                                setState(() {
                                  selected[version.name] = value;
                                });
                              },
                            );
                          }).toList()
                        ],
                      ).toList()
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
