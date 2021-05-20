import 'package:flutter/material.dart';

import '../../common/molecules/list_tile.dart';
import '../models/compression_asset.model.dart';
import 'compression_status.dart';

/// Compression item
class CompressionItem extends StatelessWidget {
  /// Constructor
  CompressionItem(
    this.asset, {
    Key key,
  }) : super(key: key ?? Key(asset.original.path));

  /// Asset
  final CompressionAsset asset;

  @override
  Widget build(BuildContext context) {
    return SkListTile(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.file(
          asset.original.file,
          height: 50,
          width: 50,
        ),
      ),
      title: Text('test'),
      trailing: CompressionStatus(asset),
    );
  }
}
