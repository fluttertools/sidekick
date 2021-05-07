import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../utils/open_link.dart';

/// Github info for a package
class PackageGithubInfo extends StatelessWidget {
  /// Constructor
  const PackageGithubInfo(
    this.repo, {
    Key key,
  }) : super(key: key);

  /// Package repository
  final Repository repo;
  @override
  Widget build(BuildContext context) {
    // Check if repo is null
    if (repo == null) {
      return Container();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 10),
        TextButton.icon(
          onPressed: () {
            openLink("${repo.htmlUrl}/stargazers");
          },
          icon: const Icon(Icons.star, size: 15),
          label: Text(repo.stargazersCount.toString()),
        ),
        const SizedBox(width: 10),
        TextButton.icon(
          onPressed: () {
            openLink("${repo.htmlUrl}/issues");
          },
          icon: const Icon(MdiIcons.alertCircleOutline, size: 15),
          label: Text(repo.openIssuesCount.toString()),
        ),
        const SizedBox(width: 10),
        TextButton.icon(
          onPressed: () {
            openLink("${repo.htmlUrl}/network/members");
          },
          icon: const Icon(MdiIcons.sourceFork, size: 15),
          label: Text(repo.forksCount.toString()),
        ),
      ],
    );
  }
}
