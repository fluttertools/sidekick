import 'package:before_after/before_after.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fvm/fvm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/components/atoms/loading_indicator.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/modules/image_compression/components/image_asset_status.dart';
import 'package:sidekick/modules/image_compression/models/image_asset.model.dart';
import 'package:sidekick/modules/image_compression/providers/compression_activity.provider.dart';
import 'package:sidekick/modules/image_compression/providers/project_images.provider.dart';
import 'package:truncate/truncate.dart';

class ImageCompressionScreen extends HookWidget {
  final Project project;
  const ImageCompressionScreen({
    this.project,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projectImages =
        useProvider(projectImagesProvider(project.projectDir));

    void handleCompressImages(List<ImageAsset> assets) async {
      final stopwatch = Stopwatch()..start();
      await context.read(compressionActivityProvider).compressAll(assets);
      print(stopwatch.elapsed);
    }

    void beforeAndAfterDialog() {
      showDialog(
          context: context,
          builder: (context) {
            return Container(
              child: BeforeAfter(
                afterImage: Image.asset(
                  '/Users/leofarias/Library/Caches/img_1618610365112.ImageFormat.png',
                ),
                beforeImage: Image.asset(
                  '/Users/leofarias/Library/Caches/img_1618610365112.ImageFormat.png',
                ),
              ),
            );
          });
    }

    List<DataCell> renderCells(ImageAsset asset) {
      return [
        DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Image.asset(
              asset.path,
              height: 50,
              width: 50,
            ),
          ),
        ),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(asset.name),
              Caption(
                truncate(
                  asset.path,
                  30,
                  position: TruncatePosition.middle,
                ),
              )
            ],
          ),
        ),
        DataCell(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Caption(filesize(asset.size)),
            ],
          ),
        ),
        DataCell(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageAssetStatus(asset),
            ],
          ),
        ),
      ];
    }

    List<DataRow> renderRows(List<ImageAsset> assets) {
      return assets.map((asset) {
        return DataRow(cells: renderCells(asset));
      }).toList();
    }

    return projectImages.when(
      data: (assets) {
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
                trailing: IconButton(
                  icon: const Icon(MdiIcons.zipBox),
                  onPressed: () {
                    beforeAndAfterDialog();
                    // handleCompressImages(assets);
                  },
                ),
              ),
              const Divider(height: 0),
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: DataTable(
                        columns: const [
                          DataColumn(
                            label: Text('Preview'),
                          ),
                          DataColumn(
                            label: Text('Info'),
                          ),
                          DataColumn(
                            label: Text('Size'),
                          ),
                          DataColumn(
                            label: Text('Savings'),
                          ),
                        ],
                        rows: renderRows(assets),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
      loading: () => const LoadingIndicator(),
      error: (_, __) => Container(
        child: const Text(
          "There was an issue loading your packages.",
        ),
      ),
    );
  }
}
