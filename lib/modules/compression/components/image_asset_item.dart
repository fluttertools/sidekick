import 'package:flutter/material.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/modules/compression/models/image_asset.model.dart';

class ImageAssetItem extends StatelessWidget {
  final ImageAsset asset;
  ImageAssetItem(
    this.asset, {
    Key key,
  }) : super(key: key ?? Key(asset.path));

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.file(
        asset.file,
        height: 50,
        width: 50,
      ),
      title: Caption(asset.name),
    );
  }
}
