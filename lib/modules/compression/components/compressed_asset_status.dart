import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/modules/compression/components/before_after_dialog.dart';
import 'package:sidekick/modules/compression/models/compression_asset.model.dart';

class CompressedAssetStatus extends HookWidget {
  final CompressedAsset asset;
  const CompressedAssetStatus(
    this.asset, {
    key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (asset == null) {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    }

    if (asset.hasError) {
      return Tooltip(
        message: asset.errorMsg,
        child: const Icon(MdiIcons.alertCircle),
      );
    }

    if (asset.status == CompressionStatus.started) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(),
      );
    }

    if (asset.status == CompressionStatus.completed && asset.isSmaller) {
      return Row(
        // mainAxisSize: MainAxisSize.min,

        children: [
          Caption(filesize(asset.compressed.size)),
          const SizedBox(width: 10),
          Chip(
            label: Caption(asset.savingsPercentage),
          ),
          const Spacer(),
          IconButton(
              icon: const Icon(MdiIcons.compare),
              onPressed: () {
                showBeforeAndAfterDialog(
                  context,
                  before: asset.original,
                  after: asset.compressed,
                );
              })
        ],
      );
    }

    // Is completed but it was not smaller
    if (asset.status == CompressionStatus.completed) {
      return Row(
        children: const [
          Icon(
            MdiIcons.check,
            size: 15,
          ),
          SizedBox(width: 10),
          Caption(
            'Optimized',
          )
        ],
      );
    }

    return const SizedBox(height: 0, width: 0);
  }
}
