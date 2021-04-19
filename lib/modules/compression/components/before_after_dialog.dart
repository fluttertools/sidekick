import 'package:before_after/before_after.dart';
import 'package:flutter/material.dart';
import 'package:sidekick/modules/compression/models/image_asset.model.dart';
import 'package:sidekick/utils/open_link.dart';

void showBeforeAndAfterDialog(
  BuildContext context, {
  ImageAsset before,
  ImageAsset after,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.all(20),
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
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  openLink(
                    "file://${before.path.replaceAll("\\", "/")}",
                  );
                },
                child: Text('Open File'),
              )
            ],
          ),
        ),
      );
    },
  );
}
