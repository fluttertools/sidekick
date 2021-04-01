import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/dto/version.dto.dart';
import 'package:sidekick/providers/fvm_queue.provider.dart';

class SetupButton extends StatelessWidget {
  final VersionDto version;
  const SetupButton({this.version, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'SDK has not finished setup',
      child: IconButton(
        icon: const Icon(MdiIcons.alert),
        iconSize: 20,
        color: Colors.cyan,
        onPressed: () {
          context.read(fvmQueueProvider).setup(version.name);
        },
      ),
    );
  }
}
