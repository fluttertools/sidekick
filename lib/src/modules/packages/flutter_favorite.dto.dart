// To parse this JSON data, do
//
//     final flutterFavorite = flutterFavoriteFromMap(jsonString);

import 'dart:convert';

class FlutterFavorite {
  FlutterFavorite({
    this.name,
    this.version,
    this.description,
    this.url,
    this.changelogUrl,
    this.grantedPoints,
    this.maxPoints,
    this.likeCount,
    this.popularityScore,
    this.lastUpdated,
  });

  final String name;
  final String version;
  final String description;
  final String url;
  final String changelogUrl;
  final String grantedPoints;
  final String maxPoints;
  final String likeCount;
  final String popularityScore;
  final DateTime lastUpdated;

  factory FlutterFavorite.fromJson(String str) =>
      FlutterFavorite.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FlutterFavorite.fromMap(Map<String, dynamic> json) => FlutterFavorite(
        name: json['name'],
        version: json['version'],
        description: json['description'],
        url: json['url'],
        changelogUrl: json['changelogUrl'],
        grantedPoints: json['grantedPoints'],
        maxPoints: json['maxPoints'],
        likeCount: json['likeCount'],
        popularityScore: json['popularityScore'],
        lastUpdated: DateTime.parse(json['lastUpdated']),
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'version': version,
        'description': description,
        'url': url,
        'changelogUrl': changelogUrl,
        'grantedPoints': grantedPoints,
        'maxPoints': maxPoints,
        'likeCount': likeCount,
        'popularityScore': popularityScore,
        'lastUpdated': lastUpdated.toIso8601String(),
      };
}
