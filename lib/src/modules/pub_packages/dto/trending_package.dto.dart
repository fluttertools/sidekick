// To parse this JSON data, do
//
//     final trendingPackage = trendingPackageFromMap(jsonString);

import 'dart:convert';

class TrendingPackage {
  TrendingPackage({
    this.owner,
    this.repoName,
    this.description,
    this.programmingLanguage,
    this.programmingLanguageColor,
    this.totalStars,
    this.starsSince,
    this.totalForks,
    this.topContributors,
  });

  final String owner;
  final String repoName;
  final String description;
  final String programmingLanguage;
  final String programmingLanguageColor;
  final int totalStars;
  final String starsSince;
  final int totalForks;
  final List<TopContributor> topContributors;

  factory TrendingPackage.fromJson(String str) =>
      TrendingPackage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TrendingPackage.fromMap(Map<String, dynamic> json) => TrendingPackage(
        owner: json['owner'],
        repoName: json['repoName'],
        description: json['description'],
        programmingLanguage: json['programmingLanguage'],
        programmingLanguageColor: json['programmingLanguageColor'],
        totalStars: json['totalStars'],
        starsSince: json['starsSince'],
        totalForks: json['totalForks'],
        topContributors: List<TopContributor>.from(
            json['topContributors'].map((x) => TopContributor.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'owner': owner,
        'repoName': repoName,
        'description': description,
        'programmingLanguage': programmingLanguage,
        'programmingLanguageColor': programmingLanguageColor,
        'totalStars': totalStars,
        'starsSince': starsSince,
        'totalForks': totalForks,
        'topContributors':
            List<dynamic>.from(topContributors.map((x) => x.toMap())),
      };
}

class TopContributor {
  TopContributor({
    this.name,
    this.avatar,
  });

  final String name;
  final String avatar;

  factory TopContributor.fromJson(String str) =>
      TopContributor.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TopContributor.fromMap(Map<String, dynamic> json) => TopContributor(
        name: json['name'],
        avatar: json['avatar'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'avatar': avatar,
      };
}
