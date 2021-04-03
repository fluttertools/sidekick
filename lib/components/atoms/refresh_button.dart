import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RefreshButton extends StatelessWidget {
  final bool refreshing;
  final Function() onPressed;
  const RefreshButton({
    this.refreshing,
    this.onPressed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Renders the refreshing indicator
    Widget renderIndicator() {
      return const Padding(
        padding: EdgeInsets.only(left: 5),
        child: SizedBox(
          height: 15,
          width: 15,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }

    return OutlinedButton.icon(
      label: const Text('Refresh'),
      icon: refreshing
          ? renderIndicator()
          : const Icon(MdiIcons.refresh, size: 20),
      onPressed: onPressed,
    );
  }
}
