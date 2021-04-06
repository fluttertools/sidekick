import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CheckButton extends HookWidget {
  final bool value;
  final Function(bool) onChanged;
  final String label;
  const CheckButton({this.label, this.value, this.onChanged, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final active = useState(false);

    // Render icon logic
    Icon renderIcon() {
      return Icon(
        value ? MdiIcons.checkboxMarked : MdiIcons.checkboxBlankOutline,
        size: 15,
      );
    }

    return OutlinedButton.icon(
      label: Text(label),
      icon: renderIcon(),
      onPressed: () {
        active.value = !active.value;
        onChanged(active.value);
      },
    );
  }
}
