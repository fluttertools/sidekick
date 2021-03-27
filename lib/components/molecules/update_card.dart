import 'package:flutter/material.dart';

class UpdateAvailableCard extends StatelessWidget {
  const UpdateAvailableCard(
    this.installl,
    this.toastDismiss, {
    Key key,
  }) : super(key: key);

  final Function installl;
  final Function toastDismiss;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.update_rounded),
            const SizedBox(
              width: 15,
            ),
            const Text(
              "There is an update available!"
              " Click here to install it now.",
            ),
            const SizedBox(
              width: 15,
            ),
            OutlinedButton.icon(
              onPressed: installl,
              icon: const Icon(
                Icons.file_download,
                size: 18,
              ),
              label: const Text(
                "Install Now",
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            TextButton(
              onPressed: toastDismiss,
              child: const Text("Later"),
            )
          ],
        ),
      ),
    );
  }
}
