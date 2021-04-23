import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/providers/fvm_cache.provider.dart';
import 'package:sidekick/providers/fvm_queue.provider.dart';
import 'package:sidekick/utils/notify.dart';

Future<void> cleanupUnusedDialog(BuildContext context) async {
  final unusedVersions = context.read(unusedVersionProvider);

  if (unusedVersions.isEmpty) {
    notify('No unused Flutter SDK versions installed');
    return;
  }

  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Heading('Cleanup unused versions'),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: const Text("Cancel"),
              style: ButtonStyle(
                  padding: MaterialStateProperty.resolveWith(
                (states) => const EdgeInsets.all(20),
              )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Confirm"),
              style: ButtonStyle(
                  padding: MaterialStateProperty.resolveWith(
                (states) => const EdgeInsets.all(20),
              )),
              onPressed: () async {
                for (var version in unusedVersions) {
                  context.read(fvmQueueProvider.notifier).remove(version);
                }

                Navigator.of(context).pop();
              },
            ),
          ],
          content: Container(
            constraints: const BoxConstraints(maxWidth: 350),
            child: CupertinoScrollbar(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        const Subheading(
                          'These version are not pinned to a project'
                          ' Do you want to remove them to free up space?',
                        ),
                        const SizedBox(height: 10),
                        ...unusedVersions.map((v) {
                          return Column(
                            children: [
                              ListTile(title: Text(v.name)),
                              const Divider(),
                            ],
                          );
                        }).toList()
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
