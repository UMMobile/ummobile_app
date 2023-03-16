import 'dart:convert';

List<Departments> departmentsFromJson(String str) => List<Departments>.from(
    json.decode(str).map((x) => Departments.fromJson(x)));

String departmentsToJson(List<Departments> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Departments {
  Departments({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  int userId;
  int id;
  String title;
  String body;

  factory Departments.fromJson(Map<String, dynamic> json) => Departments(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
      };
}
