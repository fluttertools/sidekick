import 'package:before_after/before_after.dart';
import 'package:flutter/material.dart';

import '../models/image_asset.model.dart';

void showBeforeAndAfterDialog(
  BuildContext context, {
  ImageAsset before,
  ImageAsset after,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BeforeAfter(
              beforeImage: Image.file(
                before.file,
                height: 400,
                width: 400,
                fit: BoxFit.contain,
              ),
              afterImage: Image.file(
                after.file,
                height: 400,
                width: 400,
                fit: BoxFit.contain,
              ),
            ),
            // LocalLinkButton(after.file.path)
          ],
        ),
      );
    },
  );
}
