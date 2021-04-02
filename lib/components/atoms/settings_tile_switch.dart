import 'package:flutter/material.dart';
import 'package:sidekick/components/atoms/settings_tile.dart';

class FvmSettingsTileSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  final Function(bool) onToggle;
  final bool switchValue;

  const FvmSettingsTileSwitch({
    Key key,
    this.icon,
    @required this.title,
    this.subtitle,
    this.onToggle,
    this.switchValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FvmSettingsTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 50),
          Switch(
            value: switchValue,
            onChanged: onToggle,
          ),
        ],
      ),
    );
    // return FvmSettingsTile(title: title);
  }
}
