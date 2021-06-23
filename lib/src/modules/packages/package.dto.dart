import 'package:flutter/material.dart';
import 'package:pub_api_client/pub_api_client.dart';

/// Package Detail
class PackageDetail {
  /// Constructor
  PackageDetail({
    this.name,
    this.description,
    this.version,
    this.url,
    this.homepage,
    this.changelogUrl,
    this.score,
    this.projectsCount,
  });

  @required

  ///  Name
  final String name;
  @required

  ///  Description
  final String description;
  @required

  ///  Version
  final String version;
  @required

  ///  Url
  final String url;
  @required

  ///  Homepage
  final String homepage;
  @required

  /// ChangelogUrl
  final String changelogUrl;
  @required

  /// Score
  final PackageScore score;
  @required

  /// Projects count
  final int projectsCount;
  @required

  /// Compare method
  int compareTo(PackageDetail other) {
    if (other.projectsCount > projectsCount) return -1;
    if (other.projectsCount == projectsCount) return 0;
    return 1;
  }

  /// Get Package detail from json
  PackageDetail.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        version = json['version'],
        url = json['url'],
        homepage = json['homepage'],
        changelogUrl = json['changelogUrl'],
        score =
            json['score'] != null ? PackageScore.fromJson(json['score']) : 0,
        projectsCount = json['count'];

  /// Turn package detail to json
  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'version': version,
        'url': url,
        'homepage': homepage,
        'changelogUrl': changelogUrl,
        'score': score,
        'count': projectsCount,
      };
}
