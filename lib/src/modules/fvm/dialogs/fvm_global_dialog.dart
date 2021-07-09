import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fvm/fvm.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/generated/l10n.dart';

import '../../../components/atoms/copy_button.dart';
import '../../../components/atoms/typography.dart';
import '../../common/utils/open_link.dart';

Future<void> showGlobalInfoDialog(BuildContext context) async {
  final configured = await FVMClient.checkIfGlobalConfigured();

  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Heading(S.of(context).globalConfiguration),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.resolveWith(
                (states) => const EdgeInsets.all(20),
              )),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).ok),
            ),
          ],
          content: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Subheading(
                  S.of(context).flutterPathIsPointingTon,
                ),
                Caption('${configured.currentPath}.\n\n'),
                !configured.isSetup
                    ? Column(
                        children: [
                          Subheading(
                            S.of(context).changeThePathTo +
                                S.of(context).ifYouWantToFlutterSdkThroughFvm,
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
                  label: Text(
                    S.of(context).howToUpdateYourPath,
                  ),
                )
              ],
            ),
          ),
        );
      });
}
