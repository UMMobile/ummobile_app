// To parse this JSON data, do
//
//     final areas = areasFromJson(jsonString);

import 'dart:convert';

List<Areas> areasFromJson(String str) =>
    List<Areas>.from(json.decode(str).map((x) => Areas.fromJson(x)));

String areasToJson(List<Areas> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Areas {
  Areas({
    required this.areaId,
    required this.orden,
    required this.nombre,
    required this.referente,
    required this.fechaCreado,
    required this.fechaModificado,
  });

  String areaId;
  int orden;
  String nombre;
  Referente referente;
  DateTime fechaCreado;
  DateTime fechaModificado;

  factory Areas.fromJson(Map<String, dynamic> json) => Areas(
        areaId: json["areaId"],
        orden: json["orden"],
        nombre: json["nombre"],
        referente: referenteValues.map[json["referente"]]!,
        fechaCreado: DateTime.parse(json["fechaCreado"]),
        fechaModificado: DateTime.parse(json["fechaModificado"]),
      );

  get id => null;

  Map<String, dynamic> toJson() => {
        "areaId": areaId,
        "orden": orden,
        "nombre": nombre,
        "referente": referenteValues.reverse[referente],
        "fechaCreado": fechaCreado.toIso8601String(),
        "fechaModificado": fechaModificado.toIso8601String(),
      };
}

enum Referente { EMPTY }

final referenteValues = EnumValues({"-": Referente.EMPTY});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

List<Questions> questionsFromJson(String str) =>
    List<Questions>.from(json.decode(str).map((x) => Questions.fromJson(x)));

String questionsToJson(List<Questions> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Questions {
  Questions({
    required this.preguntaId,
    required this.area,
    required this.descripcion,
    required this.tipoRespuesta,
    required this.orden,
    required this.fechaCreado,
    required this.fechaModificado,
  });

  String preguntaId;
  Areas area;
  String descripcion;
  String tipoRespuesta;
  int orden;
  DateTime fechaCreado;
  DateTime fechaModificado;

  factory Questions.fromJson(Map<String, dynamic> json) => Questions(
        preguntaId: json["preguntaId"],
        area: Areas.fromJson(json["area"]),
        descripcion: json["descripcion"],
        tipoRespuesta: json["tipoRespuesta"],
        orden: json["orden"],
        fechaCreado: DateTime.parse(json["fechaCreado"]),
        fechaModificado: DateTime.parse(json["fechaModificado"]),
      );

  Map<String, dynamic> toJson() => {
        "preguntaId": preguntaId,
        "area": area.toJson(),
        "descripcion": descripcion,
        "tipoRespuesta": tipoRespuesta,
        "orden": orden,
        "fechaCreado": fechaCreado.toIso8601String(),
        "fechaModificado": fechaModificado.toIso8601String(),
      };
}
