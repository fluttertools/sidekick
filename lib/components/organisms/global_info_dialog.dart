import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fvm/fvm.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../utils/open_link.dart';
import '../atoms/copy_button.dart';
import '../atoms/typography.dart';

Future<void> showGlobalInfoDialog(BuildContext context) async {
  final configured = await FVMClient.checkIfGlobalConfigured();

  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Heading('Global configuration'),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              style: ButtonStyle(
                  padding: MaterialStateProperty.resolveWith(
                (states) => const EdgeInsets.all(20),
              )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          content: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Subheading(
                  "Flutter PATH is pointing to\n ",
                ),
                Caption("${configured.currentPath}.\n\n"),
                !configured.isSetup
                    ? Column(
                        children: [
                          const Subheading(
                            "Change the path to\n"
                            "if you want to Flutter SDK through FVM",
                          ),
                          Row(
                            children: [
                              Caption('${configured.correctPath}'),
                              CopyButton('${configured.correctPath}')
                            ],
                          )
                        ],
                      )
                    : Container(),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () {
                    final os = Platform.operatingSystem;
                    openLink(
                      'https://flutter.dev/docs/get-started/install/$os#update-your-path',
                    );
                  },
                  icon: const Icon(MdiIcons.informationOutline),
                  label: const Text(
                    'How to update your path?',
                  ),
                )
              ],
            ),
          ),
        );
      });
}
