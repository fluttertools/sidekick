import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/components/atoms/setup_button.dart';
import 'package:sidekick/dto/channel.dto.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/providers/fvm_queue.provider.dart';

class VersionInstallStatusMaster extends StatelessWidget {
  final ChannelDto masterChannel;

  const VersionInstallStatusMaster(this.masterChannel, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// TODO: Check if is up to date after settings merge
    // useEffect(() {

    // }, [masterChannel]);

    // If pending setup
    if (masterChannel.needSetup) {
      return SetupButton(version: masterChannel);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: 'Upgrade master to latest version',
          child: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read(fvmQueueProvider).upgrade(masterChannel.name);
            },
          ),
        ),
        const Icon(MdiIcons.checkCircle, size: 20),
        SizedBox(width: masterChannel.isChannel ? 10 : 0),
        Text('${masterChannel.sdkVersion}'),
      ],
    );
  }
}
