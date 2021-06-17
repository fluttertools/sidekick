import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/generated/l10n.dart';

import '../../dto/release.dto.dart';
import '../../modules/fvm/fvm_queue.provider.dart';

/// Setup button
class SetupButton extends StatelessWidget {
  /// Constructor
  const SetupButton({
    this.release,
    Key key,
  }) : super(key: key);

  /// Release
  final ReleaseDto release;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: S.of(context).sdkHasNotFinishedSetup,
      child: IconButton(
        icon: const Icon(MdiIcons.alert),
        iconSize: 20,
        splashRadius: 20,
        color: Theme.of(context).accentColor,
        onPressed: () {
          context.read(fvmQueueProvider.notifier).setup(release);
        },
      ),
    );
  }
}
