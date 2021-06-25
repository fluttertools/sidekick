import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fvm/fvm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/src/modules/compression/compression_utils.dart';

import '../../../components/atoms/typography.dart';
import '../../common/atoms/empty_dataset.dart';
import '../../common/atoms/loading_indicator.dart';
import '../components/compression_item.dart';
import '../compression.provider.dart';

/// Image compression screen
class ImageCompressionScreen extends HookWidget {
  /// Constructor
  const ImageCompressionScreen({
    this.project,
    Key key,
  }) : super(key: key);

  /// Project
  final Project project;

  @override
  Widget build(BuildContext context) {
    final pod = compressStatePod(project.projectDir);
    final notifier = useProvider(pod.notifier);
    final state = useProvider(pod);

    if (state.isLoading) {
      return SkLoadingIndicator();
    }

    if (state.assets.isEmpty) {
      return EmptyDataset();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(MdiIcons.imageSizeSelectSmall),
            SizedBox(width: 10),
            Subheading('Optimize Assets'),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: ListTile(
            dense: true,
            title: Text(project.name),
            subtitle: Text(project.projectDir.path),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.stats.original.toString()),
                const SizedBox(width: 10),
                Text(state.stats.savings.toString()),
                IconButton(
                  splashRadius: 20,
                  icon: const Icon(MdiIcons.play),
                  onPressed: () async {
                    await notifier.compress();
                    await applyCompressionChanges(state.assets);
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            iconSize: 15,
            splashRadius: 15,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: ListView.separated(
        separatorBuilder: (_, __) => const Divider(),
        itemCount: state.assets.length,
        itemBuilder: (context, idx) {
          final asset = state.assets[idx];
          return CompressionItem(asset);
        },
      ),
    );
  }
}
