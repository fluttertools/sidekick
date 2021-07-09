import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/src/modules/../components/atoms/loading_indicator.dart';
import 'package:sidekick/src/modules/pub_packages/components/packages_empty.dart';
import 'package:sidekick/src/modules/pub_packages/components/trending_package_list_item.dart';
import 'package:sidekick/src/modules/pub_packages/pub_packages.provider.dart';

class TrendingSection extends HookWidget {
  const TrendingSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final packages = useProvider(githubTrendingProvider);
    return packages.when(
      data: (data) {
        if (data.isEmpty) {
          return const EmptyPackages();
        }
        return Container(
          child: Scrollbar(
            child: ListView.separated(
              // separatorBuilder: (_, __) => const Divider(),
              itemCount: data.length,
              separatorBuilder: (_, __) => Divider(
                thickness: 1,
                height: 0,
              ),
              itemBuilder: (context, index) {
                final package = data[index];

                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: TrendingGithubRepoItem(package),
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
