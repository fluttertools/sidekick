import 'package:flutter/material.dart';
import 'package:i18next/i18next.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../components/atoms/empty_dataset.dart';

/// Empty project screen
class EmptyProjects extends StatelessWidget {
  /// Constructor
  const EmptyProjects({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyDataset(
      icon: const Icon(MdiIcons.folder),
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              I18Next.of(context).t(
                  'modules:projects.components.noFlutterProjectsHaveBeenAddedYet'),
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              I18Next.of(context).t(
                  'modules:projects.components.addYourFlutterProjectProjectsInformationWillBeDisplayedHere'),
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
