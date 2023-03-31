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
