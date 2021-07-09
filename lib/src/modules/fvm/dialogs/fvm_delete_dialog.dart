import 'package:flutter/material.dart';
import 'package:sidekick/generated/l10n.dart';

import '../../common/dto/release.dto.dart';

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
        title: Text(S.of(context).areYouSureYouWantToRemove),
        content: Text(
            S.of(context).thisWillRemoveItemnameCacheFromYourSystem(item.name)),
        buttonPadding: const EdgeInsets.all(15),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              onDelete();
            },
            child: Text(S.of(context).confirm),
          ),
        ],
      );
    },
  );
}
