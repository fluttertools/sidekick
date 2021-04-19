import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fvm/fvm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/modules/compression/components/compressed_asset_list.dart';
import 'package:sidekick/modules/compression/compression_utils.dart';
import 'package:sidekick/modules/compression/models/compression_asset.model.dart';
import 'package:sidekick/modules/compression/models/image_asset.model.dart';
import 'package:sidekick/modules/compression/providers/compression.provider.dart';

class CompressionScreen extends HookWidget {
  final Project project;
  const CompressionScreen({
    this.project,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final processing = useState(true);
    final assets = useState<List<ImageAsset>>([]);
    final compressedAssets = useProvider(compressedListProvider);
    final completedAssets = useState(0);
    final progress = useState<double>(0.0);

    void compressAllImages() async {
      final stopwatch = Stopwatch()..start();
      assets.value = await scanForImages(project.projectDir);
      await context.read(compressedProvider).compressAll(assets.value);
      print(stopwatch.elapsed);
      processing.value = false;
    }

    useValueChanged(compressedAssets, (_, __) {
      final completed = compressedAssets
          .where((item) => item.status == CompressionStatus.completed)
          .toList();
      progress.value = completed.length / assets.value.length;
      completedAssets.value = completed.length;
    });

    useEffect(() {
      compressAllImages();
    }, []);

    Widget renderNotice() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(value: progress.value),
              const SizedBox(height: 10),
              Heading(
                  '${completedAssets.value.toString()}/${assets.value.length.toString()}'),
              const SizedBox(height: 10),
              const Heading('Scanning for optimization opportunities'),
              const SizedBox(height: 10),
              Caption(project.projectDir.path),
            ],
          ),
        ],
      );
    }

    return Scaffold(
        // backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(MdiIcons.imageSizeSelectSmall),
              SizedBox(width: 10),
              Subheading('Optimize Assets'),
            ],
          ),
          actions: const [
            CloseButton(),
            SizedBox(width: 10),
          ],
        ),
        body: Container(
          child: processing.value
              ? renderNotice()
              : CompressedAssetList(compressedAssets),
        ));
  }
}
