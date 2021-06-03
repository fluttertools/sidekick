import 'package:flutter/material.dart';

import '../../dto/release.dto.dart';

void showDeleteDialog(
  BuildContext context, {
  ReleaseDto item,
  @required Function onDelete,
}) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (context) {
      // return object of type Dialog
      return AlertDialog(
        title: const Text('Are you sure you want to remove?'),
        content: Text('This will remove ${item.name} cache from your system.'),
        buttonPadding: const EdgeInsets.all(15),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              onDelete();
            },
            child: const Text('Confirm'),
          ),
        ],
      );
    },
  );
}
