import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sidekick/src/modules/common/utils/helpers.dart';

import '../../../components/atoms/empty_dataset.dart';
import '../../navigation/navigation.provider.dart';

class EmptyVersions extends ConsumerWidget {
  const EmptyVersions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return EmptyDataset(
      icon: const FlutterLogo(),
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.i18n('modules:fvm.components.flutterSdkNotInstalled'),
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              context.i18n(
                  'modules:fvm.components.noFlutterVersionInstalledMessage'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ButtonStyle(
                  padding: MaterialStateProperty.resolveWith(
                (states) => const EdgeInsets.fromLTRB(30, 15, 30, 15),
              )),
              onPressed: () {
                ref
                    .read(navigationProvider.notifier)
                    .goTo(NavigationRoutes.exploreScreen);
              },
              icon: const Icon(Icons.explore),
              label: Text(
                context.i18n('modules:fvm.components.exploreFlutterReleases'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
