import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../components/atoms/typography.dart';
import '../models/compression_asset.model.dart';
import 'before_after_dialog.dart';

/// Compression status
class CompressionStatus extends HookWidget {
  /// Constructor
  const CompressionStatus(
    this.asset, {
    key,
  }) : super(key: key);

  /// Compress asset status
  final CompressionAsset asset;
  @override
  Widget build(BuildContext context) {
    final status = asset.status;

    if (status == Status.error) {
      return Tooltip(
        message: asset.errorMsg,
        child: const Icon(MdiIcons.alertCircle),
      );
    }

    if (asset.status == Status.started) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CupertinoActivityIndicator(),
      );
    }

    if (asset.status == Status.completed && asset.isSmaller) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Caption(filesize(asset.compressed.size)),
          const SizedBox(width: 10),
          Chip(
            label: Caption(asset.savingsPercentage),
          ),
          SizedBox(width: 20),
          IconButton(
            icon: const Icon(MdiIcons.compare),
            onPressed: () {
              showBeforeAndAfterDialog(
                context,
                before: asset.original,
                after: asset.compressed,
              );
            },
          )
        ],
      );
    }

    // Is completed but it was not smaller
    if (asset.status == Status.completed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
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
