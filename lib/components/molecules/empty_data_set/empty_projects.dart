import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/components/atoms/empty_data_set.dart';
import 'package:sidekick/screens/settings_screen.dart';

class EmptyProjects extends StatelessWidget {
  final Function() onRetry;
  const EmptyProjects({
    this.onRetry,
    key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void openSettingsScreen() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SettingsScreen(),
        ),
      );
    }

    return EmptyDataSet(
      icon: const Icon(MdiIcons.folder),
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No Flutter Projects Found',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              '''Configure the location of your Flutter Projects. Projects information will be displayed here.''',
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ButtonStyle(
                  padding: MaterialStateProperty.resolveWith(
                (states) => const EdgeInsets.fromLTRB(30, 15, 30, 15),
              )),
              onPressed: openSettingsScreen,
              icon: const Icon(Icons.settings, size: 20),
              label: const Text('Change Settings'),
            ),
            const SizedBox(height: 10),
            onRetry != null
                ? OutlinedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(MdiIcons.refresh, size: 20),
                    label: const Text('Retry'),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
