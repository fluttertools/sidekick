import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/src/modules/common/atoms/loading_indicator.dart';
import 'package:sidekick/src/modules/packages/components/flutter_favorite_list_item.dart';
import 'package:sidekick/src/modules/packages/components/packages_empty.dart';
import 'package:sidekick/src/modules/packages/packages.provider.dart';

class FlutterFavoriteScene extends HookWidget {
  const FlutterFavoriteScene({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favorites = useProvider(flutterFavoritesProvider);
    return favorites.when(
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
                  child: FlutterFavoriteListItem(package),
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
