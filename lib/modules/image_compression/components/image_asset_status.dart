import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/modules/image_compression/models/image_asset.model.dart';
import 'package:sidekick/modules/image_compression/providers/compression_activity.provider.dart';

class ImageAssetStatus extends HookWidget {
  final ImageAsset asset;
  const ImageAssetStatus(
    this.asset, {
    key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activityProvider = useProvider(compressionActivityProvider.state);

    final activity = activityProvider[asset.id];

    if (activity == null) {
      return IconButton(
        icon: const Icon(MdiIcons.play),
        onPressed: () {
          context.read(compressionActivityProvider).compressOne(asset);
        },
      );
    }

    if (activity.hasError) {
      return Tooltip(
        message: activity.errorMsg,
        child: const Icon(MdiIcons.alertCircle),
      );
    }

    if (activity.processing) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(),
      );
    }
    if (activity.completed) {
      return Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Caption(filesize(activity.compressed.size)),
          const SizedBox(width: 10),
          Chip(
            label: Caption(activity.savingsFriendly),
          ),
        ],
      );
    }

    return const SizedBox(height: 0, width: 0);
  }
}
