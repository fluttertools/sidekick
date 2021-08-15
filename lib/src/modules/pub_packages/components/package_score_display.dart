import 'package:flutter/material.dart';
import 'package:i18next/i18next.dart';
import 'package:pub_api_client/pub_api_client.dart';

import '../../../components/atoms/typography.dart';

/// Display package score
class PackageScoreDisplay extends StatelessWidget {
  /// Constructor
  const PackageScoreDisplay({
    this.score,
    Key key,
  }) : super(key: key);

  /// Package score
  final PackageScore score;
  @override
  Widget build(BuildContext context) {
    if (score == null ||
        score.popularityScore == null ||
        score.grantedPoints == null) {
      return const SizedBox(
        width: 0,
        height: 0,
      );
    }

    return Container(
      width: 242,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Heading(score.likeCount.toString()),
              Caption(I18Next.of(context)
                  .t('modules:pubPackages.components.likes')),
            ],
          ),
          const VerticalDivider(width: 25),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Heading(score.grantedPoints.toString()),
              Caption(I18Next.of(context)
                  .t('modules:pubPackages.components.pubPoints')),
            ],
          ),
          const VerticalDivider(width: 25),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Heading('${(score.popularityScore * 100).toStringAsFixed(0)}%'),
              Caption(I18Next.of(context)
                  .t('modules:pubPackages.components.popularity')),
            ],
          ),
        ],
      ),
    );
  }
}
