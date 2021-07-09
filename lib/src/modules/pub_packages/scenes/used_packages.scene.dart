import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/src/modules/../components/atoms/loading_indicator.dart';
import 'package:sidekick/src/modules/pub_packages/components/package_list_item.dart';
import 'package:sidekick/src/modules/pub_packages/components/packages_empty.dart';
import 'package:sidekick/src/modules/pub_packages/pub_packages.provider.dart';

class MostUsedScene extends HookWidget {
  const MostUsedScene({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final packages = useProvider(packagesProvider);
    return packages.when(
      data: (data) {
        if (data.isEmpty) {
          return const EmptyPackages();
        }
        return Container(
          child: Scrollbar(
            child: ListView.separated(
              separatorBuilder: (_, __) => Divider(
                thickness: 1,
                height: 0,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final package = data[index];
                final position = ++index;
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: PackageListItem(
                    package,
                    position: position,
                  ),
                );
              },
            ),
          ),
        );
      },
      loading: () => const SkLoadingIndicator(),
      error: (_, __) => Container(
        child: const Text('There was an issue loading your packages.'),
      ),
    );
  }
}
