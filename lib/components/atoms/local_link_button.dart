import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:truncate/truncate.dart';

class LocalLinkButton extends StatelessWidget {
  final String localPath;
  const LocalLinkButton(
    this.localPath, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Open $localPath',
      child: TextButton(
        onPressed: () {
          OpenFile.open(
            localPath,
          );
        },
        child: Caption(
          truncate(
            localPath,
            30,
            position: TruncatePosition.middle,
          ),
        ),
      ),
    );
  }
}
