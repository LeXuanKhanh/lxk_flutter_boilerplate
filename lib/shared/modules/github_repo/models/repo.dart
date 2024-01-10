import 'dart:convert';

List<Repo> repoFromJsonStr(String str) => List<Repo>.from(json.decode(str).map((x) => Repo.fromJson(x)));
List<Repo> repoFromJsonArr(List<dynamic> jsonArr) => jsonArr
    .map((dynamic e) => Repo.fromJson(e))
    .toList();

String repoToJson(List<Repo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Repo {
  String id;
  String name;
  bool viewerHasStarred;
  String url;
  int stargazerCount;
  bool isFork;
  int forkCount;

  Repo({
    required this.id,
    required this.name,
    required this.viewerHasStarred,
    required this.url,
    required this.stargazerCount,
    required this.isFork,
    required this.forkCount,
  });

  Repo copyWith({
    String? id,
    String? name,
    bool? viewerHasStarred,
    String? url,
    int? stargazerCount,
    bool? isFork,
    int? forkCount,
  }) =>
      Repo(
        id: id ?? this.id,
        name: name ?? this.name,
        viewerHasStarred: viewerHasStarred ?? this.viewerHasStarred,
        url: url ?? this.url,
        stargazerCount: stargazerCount ?? this.stargazerCount,
        isFork: isFork ?? this.isFork,
        forkCount: forkCount ?? this.forkCount,
      );

  factory Repo.fromJson(Map<String, dynamic> json) => Repo(
    id: json["id"],
    name: json["name"],
    viewerHasStarred: json["viewerHasStarred"],
    url: json["url"],
    stargazerCount: json["stargazerCount"],
    isFork: json["isFork"],
    forkCount: json["forkCount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "viewerHasStarred": viewerHasStarred,
    "url": url,
    "stargazerCount": stargazerCount,
    "isFork": isFork,
    "forkCount": forkCount,
  };
}