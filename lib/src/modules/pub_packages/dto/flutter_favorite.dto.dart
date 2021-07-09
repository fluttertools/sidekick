// To parse this JSON data, do
//
//     final flutterFavorite = flutterFavoriteFromMap(jsonString);

import 'dart:convert';

import 'package:pub_api_client/pub_api_client.dart';

class FlutterFavorite {
  FlutterFavorite({
    this.name,
    this.version,
    this.description,
    this.url,
    this.changelogUrl,
    this.score,
  });

  final String name;
  final String version;
  final String description;
  final String url;
  final String changelogUrl;

  final PackageScore score;

  factory FlutterFavorite.fromJson(String str) =>
      FlutterFavorite.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FlutterFavorite.fromMap(Map<String, dynamic> json) => FlutterFavorite(
        name: json['name'],
        version: json['version'],
        description: json['description'],
        url: json['url'],
        changelogUrl: json['changelogUrl'],
        score: PackageScore(
          grantedPoints: int.parse(json['grantedPoints']),
          maxPoints: int.parse((json['maxPoints'])),
          likeCount: int.parse((json['likeCount'])),
          popularityScore: double.parse((json['popularityScore'])),
          lastUpdated: DateTime.parse(
            json['lastUpdated'],
          ),
        ),
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'version': version,
        'description': description,
        'url': url,
        'changelogUrl': changelogUrl,
        'score': score.toJson()
      };
}
