import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:pub_api_client/pub_api_client.dart';

class PackageDetail {
  @required
  final String name;
  @required
  final String description;
  @required
  final String version;
  @required
  final String url;
  @required
  final String homepage;
  @required
  final String changelogUrl;
  @required
  final PackageScore score;
  @required
  final int count;
  @required
  final Repository repo;
  PackageDetail({
    this.name,
    this.description,
    this.version,
    this.url,
    this.homepage,
    this.changelogUrl,
    this.score,
    this.count,
    this.repo,
  });

  int compareTo(PackageDetail other) {
    if (other.count > count) return -1;
    if (other.count == count) return 0;
    return 1;
  }

  PackageDetail.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        version = json['version'],
        url = json['url'],
        homepage = json['homepage'],
        changelogUrl = json['changelogUrl'],
        score = PackageScore.fromJson(json['score']),
        count = json['count'],
        repo = Repository.fromJson(json['repo']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'version': version,
        'url': url,
        'homepage': homepage,
        'changelogUrl': changelogUrl,
        'score': score,
        'count': count,
        'repo': repo,
      };
}
