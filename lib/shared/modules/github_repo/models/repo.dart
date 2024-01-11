import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'repo.freezed.dart';
part 'repo.g.dart';

@freezed
class Repo with _$Repo {
  const factory Repo({
    required String id,
    required String name,
    required bool viewerHasStarred,
    required String url,
    required int stargazerCount,
    required bool isFork,
    required int forkCount,
  }) = _Repo;

  factory Repo.fromJson(Map<String, Object?> json)
  => _$RepoFromJson(json);
}