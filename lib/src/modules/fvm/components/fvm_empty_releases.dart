import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18next/i18next.dart';

import '../../../components/atoms/empty_dataset.dart';
import '../../navigation/navigation.provider.dart';

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
              I18Next.of(context)
                  .t('modules:fvm.components.flutterSdkNotInstalled'),
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              I18Next.of(context)
                  .t('modules:fvm.components.noFlutterVersionInstalledMessage'),
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
              label: Text(
                I18Next.of(context)
                    .t('modules:fvm.components.exploreFlutterReleases'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
