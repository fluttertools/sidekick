import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/atoms/loading_indicator.dart';
import '../common/organisms/screen.dart';
import 'components/package_list_item.dart';
import 'components/packages_empty.dart';
import 'package.dto.dart';
import 'packages.provider.dart';

/// Packages screen
class PackagesScreen extends HookWidget {
  /// Constructor
  const PackagesScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final packages = useProvider(packagesProvider);

    return packages.when(
      data: (data) {
        if (data.isEmpty) {
          return const EmptyPackages();
        }
        return SkScreen(
          title: 'Most Used Packages',
          child: CupertinoScrollbar(
            child: ListView.builder(
              // separatorBuilder: (_, __) => const Divider(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final PackageDetail package = data[index];
                final position = ++index;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
        child: const Text(
          'There was an issue loading your packages.',
        ),
      ),
    );
  }
}
