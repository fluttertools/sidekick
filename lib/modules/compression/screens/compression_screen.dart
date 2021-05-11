import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fvm/fvm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/components/molecules/empty_data_set/empty_versions.dart';
import 'package:sidekick/modules/compression/components/compression_item.dart';
import 'package:sidekick/modules/compression/compression_utils.dart';
import 'package:sidekick/modules/compression/models/image_asset.model.dart';
import 'package:sidekick/modules/compression/providers/compression.provider.dart';

class ImageCompressionScreen extends HookWidget {
  final Project project;
  const ImageCompressionScreen({
    this.project,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final completed = useProvider(compressionProgressProvider);
    final compressionState = useProvider(compressionStateProvider);
    final totalStat = useProvider(compressionStatProvider);
    final imageAssets = useState<List<ImageAsset>>([]);
    final hasRun = useState(false);
    final processing = useState(false);

    void handleCompressImages() async {
      processing.value = true;
      final assets = await scanForImages(project.projectDir);
      imageAssets.value = assets;
      await context.read(compressionProvider).compressAll(assets);
      processing.value = false;
      hasRun.value = true;
    }

    if (hasRun.value == false && processing.value == false) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Caption(
            'Scan your assets for ${project.name}'
            'located in ${project.projectDir.path}\n',
          ),
          ElevatedButton(
            onPressed: handleCompressImages,
            child: const Text('Scan for images'),
          )
        ],
      );
    }

    if (processing.value == true) {
      final totalAssets = imageAssets.value.length.toString();
      final finishedAssets = completed.length.toString();
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Heading('Scanning project'),
          Caption('$finishedAssets/$totalAssets')
        ],
      );
    }

    if (compressionState.isEmpty && hasRun.value) {
      return const EmptyVersions();
    }

    return Scaffold(
      // backgroundColor: Colors.black,
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
      body: Column(
        children: [
          ListTile(
            dense: true,
            title: Text(project.name),
            subtitle: Text(project.projectDir.path),
            trailing: Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(totalStat.original.toString()),
                  const SizedBox(width: 10),
                  Text(totalStat.savings.toString()),
                  IconButton(
                    splashRadius: 20,
                    icon: const Icon(MdiIcons.play),
                    onPressed: () {
                      handleCompressImages();
                    },
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 0),
          Expanded(
            child: CupertinoScrollbar(
              child: ListView.separated(
                separatorBuilder: (_, __) => const Divider(),
                itemCount: compressionState.length,
                itemBuilder: (context, idx) {
                  final image = compressionState[idx];
                  return CompressionItem(image);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
