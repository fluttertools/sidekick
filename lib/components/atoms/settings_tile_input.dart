import 'package:flutter/material.dart';
import 'package:sidekick/components/atoms/settings_tile.dart';

class FvmSettingsTileInput extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final Function(String) onChanged;

  const FvmSettingsTileInput({
    Key key,
    this.icon,
    @required this.title,
    this.subtitle,
    this.onChanged,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 2,
          child: FvmSettingsTile(
            icon: icon,
            title: title,
            subtitle: subtitle,
            trailing: null,
          ),
        ),
        Expanded(
          flex: 1,
          child: TextFormField(
            enabled: false,
            autocorrect: false,
            expands: false,
            initialValue: value,
            onChanged: onChanged,

            // decoration: InputDecoration(
            //   hintText: hintText,
            //   counterText: "",
            //   border: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(5),
            //   ),
            // ),
          ),
        ),
        const SizedBox(width: 30)
      ],
    );
    // return FvmSettingsTile(title: title);
  }
}
