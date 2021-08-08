import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18next/i18next.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../common/dto/release.dto.dart';
import '../fvm_queue.provider.dart';

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
      message: I18Next.of(context)
          .t('modules:fvm.components.sdkHasNotFinishedSetup'),
      child: IconButton(
        icon: const Icon(MdiIcons.alert),
        iconSize: 20,
        splashRadius: 20,
        color: Theme.of(context).colorScheme.secondary,
        onPressed: () {
          context.read(fvmQueueProvider.notifier).setup(release);
        },
      ),
    );
  }
}
