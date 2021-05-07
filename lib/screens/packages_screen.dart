import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components/atoms/loading_indicator.dart';
import '../components/atoms/screen.dart';
import '../components/molecules/empty_data_set/empty_packages.dart';
import '../components/molecules/package_item.dart';
import '../dto/package_detail.dto.dart';
import '../modules/packages/packages.provider.dart';

class PackagesScreen extends HookWidget {
  const PackagesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final packages = useProvider(packagesProvider);

    return packages.when(
      data: (data) {
        if (data.isEmpty) {
          return const EmptyPackages();
        }
        return Screen(
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
                  child: PackageItem(
                    package,
                    position: position,
                  ),
                );
              },
            ),
          ),
        );
      },
      loading: () => const LoadingIndicator(),
      error: (_, __) => Container(
        child: const Text(
          "There was an issue loading your packages.",
        ),
      ),
    );
  }
}
