import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../modules/common/utils/notify.dart';
import '../../modules/fvm/fvm.provider.dart';
import '../../modules/fvm/fvm_queue.provider.dart';

Future<void> cleanupUnusedDialog(BuildContext context) async {
  final unusedVersions = context.read(unusedVersionProvider);

  if (unusedVersions.isEmpty) {
    notify('No unused Flutter SDK versions installed');
    return;
  }

  await showDialog(
    context: context,
    builder: (context) {
      var selected = <String, bool>{};
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Clean up unused versions'),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Confirm"),
                onPressed: () async {
                  final unusedSelected = unusedVersions.where(
                    (element) => selected.containsKey(element.name),
                  );
                  for (final version in unusedSelected) {
                    context.read(fvmQueueProvider.notifier).remove(version);
                  }

                  Navigator.of(context).pop();
                },
              ),
            ],
            content: Container(
              constraints: const BoxConstraints(maxWidth: 350, maxHeight: 300),
              child: CupertinoScrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'These version are not pinned to a project '
                        'Do you want to remove them to free up space?',
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
