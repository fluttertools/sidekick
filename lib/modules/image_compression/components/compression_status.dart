import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sidekick/modules/image_compression/image_compression_screen.dart';

class CompressionStatus extends HookWidget {
  final CompressActivity activity;
  const CompressionStatus(
    this.activity, {
    key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final originalStat = useState<FileStat>(null);
    final compressedStat = useState<FileStat>(null);

    void loadStatusInfo() async {
      if (activity.original != null) {
        originalStat.value = await activity.original.stat();
      }

      if (activity.compressed != null) {
        compressedStat.value = await activity.compressed.stat();
      }
    }

    useValueChanged(activity, (_, __) {
      loadStatusInfo();
    });

    if (originalStat.value == null || compressedStat.value == null) {
      return const SizedBox(height: 0, width: 0);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(originalStat.value.size.toString()),
        Text(compressedStat.value.size.toString())
      ],
    );
  }
}
