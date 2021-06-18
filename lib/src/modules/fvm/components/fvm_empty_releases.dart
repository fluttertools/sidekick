import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sidekick/generated/l10n.dart';

import '../../../providers/navigation_provider.dart';
import '../../common/atoms/empty_dataset.dart';

class EmptyVersions extends StatelessWidget {
  const EmptyVersions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyDataset(
      icon: const FlutterLogo(),
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context).flutterSdkNotInstalled,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              S.of(context).noFlutterVersionInstalledMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ButtonStyle(
                  padding: MaterialStateProperty.resolveWith(
                (states) => const EdgeInsets.fromLTRB(30, 15, 30, 15),
              )),
              onPressed: () {
                context
                    .read(navigationProvider.notifier)
                    .goTo(NavigationRoutes.exploreScreen);
              },
              icon: const Icon(Icons.explore),
              label: Text(S.of(context).exploreFlutterReleases),
            )
          ],
        ),
      ),
    );
  }
}
