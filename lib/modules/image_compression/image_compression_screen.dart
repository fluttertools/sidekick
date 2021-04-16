import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fvm/fvm.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/modules/image_compression/components/compression_status.dart';
import 'package:sidekick/modules/image_compression/helpers.dart';
import 'package:truncate/truncate.dart';

class ImageCompressionScreen extends HookWidget {
  final Project project;
  const ImageCompressionScreen({
    this.project,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activities = useState<List<CompressActivity>>(null);

    void handleCompressImages() async {
      final stopwatch = Stopwatch()..start();
      activities.value = await compressAllImages(activities.value);
      print(stopwatch.elapsed);
    }

    useEffect(() {
      return;
    }, [project]);

    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(MdiIcons.abTesting),
            SizedBox(width: 10),
            Subheading('Image Compression'),
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
              icon: const Icon(MdiIcons.image),
              onPressed: () {
                handleCompressImages();
              },
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: ListView.separated(
                separatorBuilder: (_, __) => const Divider(),
                itemCount: activities.value.length,
                itemBuilder: (context, int) {
                  final image = activities.value[int];
                  return ListTile(
                    key: Key(image.original.path),
                    dense: true,
                    leading: Image.asset(
                      image.original.path,
                      fit: BoxFit.contain,
                    ),
                    title: Text(image.original.path.split('/').last),
                    subtitle: Text(
                      truncate(
                        image.original.path,
                        30,
                        position: TruncatePosition.middle,
                      ),
                    ),
                    trailing: CompressionStatus(image),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
