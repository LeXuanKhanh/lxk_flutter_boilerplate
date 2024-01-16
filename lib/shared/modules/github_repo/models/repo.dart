import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

part 'repo.freezed.dart';
part 'repo.g.dart';

List<Repo> repoFromJsonStr(String str) =>
    List<Repo>.from(json.decode(str).map((x) => Repo.fromJson(x)));
List<Repo> repoFromJsonArr(List<dynamic> jsonArr) =>
    jsonArr.map((dynamic e) => Repo.fromJson(e)).toList();

@freezed
class Repo with _$Repo {
  const factory Repo({
    required String cursor,
    required Node node,
  }) = _Repo;

  factory Repo.fromJson(Map<String, dynamic> json) => _$RepoFromJson(json);
}

@freezed
class Node with _$Node {
  const factory Node({
    required String id,
    required String name,
    required bool viewerHasStarred,
    required String url,
    required int stargazerCount,
    required bool isFork,
    required int forkCount,
    required DateTime? createdAt,
  }) = _Node;

  const Node._();

  String get createAtDateFormatted => createdAt != null
      ? DateFormat('dd-MM-yyyy').format(createdAt!)
      : '';

  factory Node.fromJson(Map<String, dynamic> json) => _$NodeFromJson(json);
}
