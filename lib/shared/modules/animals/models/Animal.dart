import 'dart:convert';

Animal animalFromJson(String str) => Animal.fromJson(json.decode(str));

String animalToJson(Animal data) => json.encode(data.toJson());

List<Animal> animalListFromJson(String str) =>
    List<Animal>.from(json.decode(str).map((x) => Animal.fromJson(x)));

List<Animal> animalListFromJsonList(List<dynamic> list) =>
    list.map((e) => Animal.fromJson(e)).toList();

String animalToJsonList(List<Animal> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Animal {
  DateTime createdAt = DateTime.now();
  String name = '';
  String avatar =
      'https://picsum.photos/${DateTime.now().second.toString()}/picsum/200/300';
  String id = '-1';

  Animal({
    required this.createdAt,
    required this.name,
    required this.avatar,
    required this.id,
  });

  factory Animal.createNew(String name) => Animal(
      createdAt: DateTime.now(),
      name: name,
      avatar:
          'https://picsum.photos/${DateTime.now().second.toString()}/picsum/200/300',
      id: '-1');

  factory Animal.fromJson(Map<String, dynamic> json) => Animal(
        createdAt: DateTime.parse(json["createdAt"]),
        name: json["name"],
        avatar: json["avatar"],
        id: json["id"],
      );

  Animal copyWith({
    DateTime? createdAt,
    String? name,
    String? avatar,
    String? id,
  }) =>
      Animal(
        createdAt: createdAt ?? this.createdAt,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        id: id ?? this.id,
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt.toIso8601String(),
        "name": name,
        "avatar": avatar,
        "id": id,
      };
}
