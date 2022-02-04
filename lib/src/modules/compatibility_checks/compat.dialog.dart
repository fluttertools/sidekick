import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/src/components/atoms/typography.dart';
import 'package:sidekick/src/modules/common/utils/notify.dart';
import 'package:sidekick/src/modules/compatibility_checks/compat.dto.dart';
import 'package:sidekick/src/modules/compatibility_checks/compat.provider.dart';

import 'compat.utils.dart';

class CompatDialog extends HookWidget {
  const CompatDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final check = useProvider(compatProvider);
    final command = _genCommand(check);

    return AlertDialog(
      title: Column(
        children: const [
          Heading("Install Required Components"),
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
              Expanded(
                child: SelectableText(
                  command,
                  //maxLines: 1,
                  //textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                  splashRadius: 2,
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: command),
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
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            notify("Great! Sidekick will now close. Please reopen it.");
            Future.delayed(const Duration(seconds: 3)).then((_) => exit(0));
          },
          child: const Text("Done"),
        )
      ],
    );
  }
}

String _genCommand(CompatibilityCheck check) {
  var command = "";
  final useBrew = (Platform.isMacOS || Platform.isLinux);
  if (!check.brew && useBrew) {
    command += brewInstallCmd;
  }
  if (!check.choco && !useBrew) {
    command += chocoInstallCmd;
  }
  if (!check.git) {
    command += gitInstallCmd;
  }
  if (!check.fvm) {
    command += fvmInstallCmd;
  }
  return command;
}
