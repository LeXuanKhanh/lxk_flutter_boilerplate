// To parse this JSON data, do
//
//     final githubUser = githubUserFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'github_user.freezed.dart';
part 'github_user.g.dart';

GithubUser githubUserFromJsonStr(String str) => GithubUser.fromJson(json.decode(str));
String githubUserToJson(GithubUser data) => json.encode(data.toJson());

@freezed
class GithubUser with _$GithubUser {
  const factory GithubUser({
    required String login,
    required String avatarUrl,
    required String email,
    required String name,
  }) = _GithubUser;

  factory GithubUser.fromJson(Map<String, dynamic> json) => _$GithubUserFromJson(json);
}
