import 'package:flutter/material.dart';
import 'package:fvm/fvm.dart';
import 'package:sidekick/components/atoms/typography.dart';

Future<void> showGlobalInfoDialog(BuildContext context) async {
  final configured = await FVMClient.checkIfGlobalConfigured();
  String content = "";
  if (!configured.isSetup) {
    content = "Flutter PATH is pointing to\n${configured.currentPath}.\n\n"
        "Change the path to\n ${configured.newPath}\n\n"
        "if you want to Flutter SDK through FVM";
  }

  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Heading('Global Version'),
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
          content: Paragraph(content),
        );
      });
}
