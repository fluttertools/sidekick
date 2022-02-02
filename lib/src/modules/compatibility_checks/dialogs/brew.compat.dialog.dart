import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sidekick/src/components/atoms/typography.dart';
import 'package:sidekick/src/modules/common/utils/notify.dart';
import 'package:sidekick/src/modules/common/utils/open_link.dart';

import '../compat.service.dart';
import '../compat.utils.dart';

class BrewDialog extends StatelessWidget {
  const BrewDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: const [
          Heading("Install Brew"),
          SizedBox(
            width: 15,
          ),
          Subheading(
              "Copy this and paste it in the terminal. Follow the instructions.")
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
              const SelectableText(
                brewInstallCmd,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
              IconButton(
                  splashRadius: 2,
                  onPressed: () {
                    Clipboard.setData(
                      const ClipboardData(text: brewInstallCmd),
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
            openLink(context, "https://brew.sh");
          },
          child: const Text("Go to project site"),
        ),
        ElevatedButton(
          onPressed: () {
            isBrewInstalled().then(
              (value) {
                print(value);
                if (value) {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) => BrewDialog(),
                  );
                  CompatService.checkState();
                } else {
                  notify("Brew is not detected,"
                      " please make sure it is installed and try again");
                }
              },
            );
          },
          child: const Text("Done"),
        )
      ],
    );
  }
}
