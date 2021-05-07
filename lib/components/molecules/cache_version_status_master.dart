import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../dto/channel.dto.dart';
import 'setup_button.dart';

class CacheVersionStatusMaster extends StatelessWidget {
  final ChannelDto masterChannel;

  const CacheVersionStatusMaster(this.masterChannel, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If pending setup
    if (masterChannel.needSetup) {
      return SetupButton(version: masterChannel);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(MdiIcons.checkCircle, size: 20),
        SizedBox(width: masterChannel.isChannel ? 10 : 0),
        Text('${masterChannel.sdkVersion}'),
      ],
    );
  }
}
