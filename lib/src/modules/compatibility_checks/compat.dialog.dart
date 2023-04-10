import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/src/modules/common/utils/helpers.dart';
import 'package:sidekick/src/modules/common/utils/notify.dart';
import 'package:sidekick/src/modules/compatibility_checks/compat.dto.dart';
import 'package:sidekick/src/modules/compatibility_checks/compat.provider.dart';

import 'compat.utils.dart';

class CompatDialog extends ConsumerWidget {
  const CompatDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final check = ref.watch(compatProvider);
    final command = _genCommand(check);

    return AlertDialog(
      title: Column(
        children: [
          const Icon(Icons.install_desktop_rounded, size: 25),
          const SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  context.i18n('modules:compatibility.dialog.dialogTitle'),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                context.i18n(Platform.isWindows
                    ? 'modules:compatibility.dialog.dialogDescriptionWindows'
                    : 'modules:compatibility.dialog.dialogDescriptionMacLinux'),
                style: Theme.of(context).textTheme.bodyMedium,
              )
            ],
          ),
        ],
      ),
      content: CommandCopy(command: command),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(context.i18n('modules:fvm.dialogs.cancel')),
        ),
        TextButton(
          onPressed: () {
            notify(context
                .i18n('modules:compatibility.dialog.dialogRestartNotication'));
            Future.delayed(const Duration(seconds: 3)).then((_) => exit(0));
          },
          child: Text(context.i18n('modules:compatibility.dialog.done')),
        )
      ],
    );
  }
}

class CommandCopy extends StatelessWidget {
  const CommandCopy({
    Key? key,
    required this.command,
  }) : super(key: key);

  final String command;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(12),
      ),
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
                  notify(context.i18n('components:atoms.copiedToClipboard'));
                },
                icon: const Icon(
                  Icons.copy,
                  size: 15,
                ))
          ],
        ),
      ),
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
