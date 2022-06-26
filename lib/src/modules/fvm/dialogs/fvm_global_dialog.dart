import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fvm/fvm.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/src/modules/common/utils/helpers.dart';
import 'package:sidekick/src/modules/compatibility_checks/compat.dialog.dart';

import '../../../components/atoms/typography.dart';
import '../../common/utils/open_link.dart';

Future<void> showGlobalInfoDialog(BuildContext context) async {
  final configured = await FVMClient.checkIfGlobalConfigured();

  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            context.i18n('modules:fvm.dialogs.globalConfiguration'),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(context.i18n('modules:fvm.dialogs.ok')),
            ),
          ],
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.i18n('modules:fvm.dialogs.flutterPathIsPointingOn'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              // Caption('${configured.currentPath}.\n\n'),
              CommandCopy(command: configured.correctPath),
              const SizedBox(height: 12),

              !configured.isSetup
                  ? Column(
                      children: [
                        Subheading(
                          context.i18n('modules:fvm.dialogs.changeThePathTo') +
                              context.i18n(
                                  'modules:fvm.dialogs.ifYouWantToFlutterSdkThroughFvm'),
                        ),
                        CommandCopy(command: configured.correctPath)
                      ],
                    )
                  : Container(),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () {
                  final os = Platform.operatingSystem;
                  openLink(
                    context,
                    'https://flutter.dev/docs/get-started/install/$os#update-your-path',
                  );
                },
                icon: const Icon(MdiIcons.informationOutline),
                label: Text(
                  context.i18n('modules:fvm.dialogs.howToUpdateYourPath'),
                ),
              )
            ],
          ),
        );
      });
}
