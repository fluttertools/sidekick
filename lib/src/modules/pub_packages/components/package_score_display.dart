import 'package:flutter/material.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:sidekick/generated/l10n.dart';

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
      width: 240,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Heading(score.likeCount.toString()),
              Caption(S.of(context).likes),
            ],
          ),
          const VerticalDivider(width: 25),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Heading(score.grantedPoints.toString()),
              Caption(S.of(context).pubPoints),
            ],
          ),
          const VerticalDivider(width: 25),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Heading('${(score.popularityScore * 100).toStringAsFixed(0)}%'),
              Caption(S.of(context).popularity),
            ],
          ),
        ],
      ),
    );
  }
}
