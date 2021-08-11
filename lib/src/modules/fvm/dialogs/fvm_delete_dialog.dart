import 'package:flutter/material.dart';
import 'package:i18next/i18next.dart';

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
        title: Text(I18Next.of(context)
            .t('modules:fvm.dialogs.areYouSureYouWantToRemove')),
        content: Text(
          I18Next.of(context).t(
            'modules:fvm.dialogs.thisWillRemoveItemnameCacheFromYourSystem',
            variables: {
              'itemname': item.name,
            },
          ),
        ),
        buttonPadding: const EdgeInsets.all(15),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(I18Next.of(context).t('modules:fvm.dialogs.cancel')),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              onDelete();
            },
            child: Text(I18Next.of(context).t('modules:fvm.dialogs.confirm')),
          ),
        ],
      );
    },
  );
}
