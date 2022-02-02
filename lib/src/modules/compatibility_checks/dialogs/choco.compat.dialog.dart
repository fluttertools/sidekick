import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sidekick/src/components/atoms/typography.dart';
import 'package:sidekick/src/modules/common/utils/notify.dart';
import 'package:sidekick/src/modules/common/utils/open_link.dart';

import '../compat.service.dart';
import '../compat.utils.dart';
import 'brew.compat.dialog.dart';

class ChocoDialog extends StatelessWidget {
  const ChocoDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: const [
          Heading("Install Chocolatey"),
          SizedBox(
            width: 15,
          ),
          Subheading(
              "Copy this and paste it in PowerShell. Follow the instructions. You need administartive rights.")
        ],
      ),
      content: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(12)),
        child: SingleChildScrollView(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Expanded(
                child: SelectableText(
                  chocoInstallCmd,
                  //maxLines: 5,
                  textAlign: TextAlign.left,
                ),
              ),
              IconButton(
                  splashRadius: 2,
                  onPressed: () {
                    Clipboard.setData(
                      const ClipboardData(text: chocoInstallCmd),
                    );
                    notify("Copied to Clipboard");
                  },
                  icon: const Icon(
                    Icons.copy,
                    size: 15,
                  ))
            ],
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            openLink(context, "https://chocolatey.org/install#individual");
          },
          child: const Text("Go to project site"),
        ),
        ElevatedButton(
          onPressed: () {
            isChocoInstalled().then((value) {
              if (value) {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (context) => const BrewDialog(),
                );
                CompatService.checkState();
              } else {
                notify("Choco is not detected,"
                    " please make sure it is installed and try again");
              }
            });
          },
          child: const Text("Done"),
        )
      ],
    );
  }
}
