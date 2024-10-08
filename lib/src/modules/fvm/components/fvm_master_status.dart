import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/src/modules/common/dto/master.dto.dart';

import 'fvm_setup_button.dart';

/// Status for Master channel release
class FvmMasterStatus extends StatelessWidget {
  /// Constructor
  const FvmMasterStatus(
    this.masterChannel, {
    super.key,
  });

  /// Master
  final MasterDto masterChannel;
  @override
  Widget build(BuildContext context) {
    // If pending setup
    if (masterChannel.needSetup) {
      return SetupButton(release: masterChannel);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(MdiIcons.checkCircle, size: 20),
        SizedBox(width: masterChannel.isChannel ? 10 : 0),
        Text(masterChannel.sdkVersion ?? ''),
      ],
    );
  }
}
