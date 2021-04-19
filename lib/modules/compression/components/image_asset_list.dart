import 'package:flutter/material.dart';
import 'package:sidekick/modules/compression/components/image_asset_item.dart';
import 'package:sidekick/modules/compression/models/image_asset.model.dart';

class ImageAssetList extends StatelessWidget {
  final List<ImageAsset> assets;
  const ImageAssetList(
    this.assets, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (_, __) => const Divider(),
      itemCount: assets.length,
      itemBuilder: (context, idx) {
        final image = assets[idx];
        return ImageAssetItem(image);
      },
    );
  }
}
