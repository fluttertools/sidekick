import 'package:flutter/material.dart';

import '../models/compression_asset.model.dart';
import 'compression_status.dart';

class CompressionItem extends StatelessWidget {
  final CompressionAsset asset;
  CompressionItem(
    this.asset, {
    Key key,
  }) : super(key: key ?? Key(asset.original.path));

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(
                asset.original.file,
                height: 50,
                width: 50,
              ),
            ),
            Flexible(
              child: Column(
                children: [
                  CompressionStatus(asset),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
