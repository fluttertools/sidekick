import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// Refresh button
class RefreshButton extends StatelessWidget {
  /// Constructor
  const RefreshButton({
    this.refreshing,
    this.onPressed,
    Key key,
  }) : super(key: key);

  /// Is refreshing
  final bool refreshing;

  /// On press handler
  final Function() onPressed;
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
