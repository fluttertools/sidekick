import 'package:flutter/material.dart';
import 'package:sidekick/src/modules/common/utils/helpers.dart';

import '../../common/dto/release.dto.dart';

void showDeleteDialog(
  BuildContext context, {
  required ReleaseDto item,
  required Function onDelete,
}) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (context) {
      // return object of type Dialog
      return AlertDialog(
        title: Text(
          context.i18n('modules:fvm.dialogs.areYouSureYouWantToRemove'),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        content: Text(
          context.i18n(
            'modules:fvm.dialogs.thisWillRemoveItemnameCacheFromYourSystem',
            variables: {
              'itemname': item.name,
            },
          ),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(context.i18n('modules:fvm.dialogs.cancel')),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              onDelete();
            },
            child: Text(context.i18n('modules:fvm.dialogs.confirm')),
          ),
        ],
      );
    },
  );
}
