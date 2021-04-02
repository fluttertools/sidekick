import 'package:flutter/material.dart';

class FvmSettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget trailing;
  final Function() onTap;
  final bool selected;

  const FvmSettingsTile({
    Key key,
    @required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      title: Text(title),
      subtitle: Text(subtitle),
      leading: icon != null ? Icon(icon) : null,
      trailing: trailing,
      selectedTileColor: Colors.white12,
      selected: selected,
      onTap: onTap,
    );
  }
}
