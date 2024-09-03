import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/src/modules/common/utils/helpers.dart';

import '../../common/utils/notify.dart';
import '../fvm.provider.dart';
import '../fvm_queue.provider.dart';

Future<void> cleanupUnusedDialog(BuildContext context, WidgetRef ref) async {
  final unusedVersions = ref.read(unusedVersionProvider);
  final scrollController = ScrollController();

  if (unusedVersions.isEmpty) {
    notify(context
        .i18n('modules:fvm.dialogs.noUnusedFlutterSdkVersionsInstalled'));
    return;
  }

  await showDialog(
    context: context,
    builder: (context) {
      var selected = <String, bool>{};
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title:
                Text(context.i18n('modules:fvm.dialogs.cleanUpUnusedVersions')),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(context.i18n('modules:fvm.dialogs.cancel')),
              ),
              TextButton(
                onPressed: () async {
                  final unusedSelected = unusedVersions.where(
                    (element) => selected.containsKey(element.name),
                  );
                  for (final version in unusedSelected) {
                    ref
                        .read(fvmQueueProvider.notifier)
                        .remove(context, version);
                  }

                  Navigator.of(context).pop();
                },
                child: Text(context.i18n('modules:fvm.dialogs.confirm')),
              ),
            ],
            content: Container(
              constraints: const BoxConstraints(maxWidth: 350, maxHeight: 300),
              child: CupertinoScrollbar(
                controller: scrollController,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Text(
                        context.i18n(
                                'modules:fvm.dialogs.theseVersionAreNotPinnedToAProject') +
                            context.i18n(
                                'modules:fvm.dialogs.doYouWantToRemoveThemToFreeUpSpace'),
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
                                  selected[version.name] = value ?? false;
                                });
                              },
                            );
                          })
                        ],
                      )
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
