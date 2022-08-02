// To parse this JSON data, do
//
//     final interes = interesFromJson(jsonString);

import 'dart:convert';

Interes interesFromJson(String str) => Interes.fromJson(json.decode(str));

String interesToJson(Interes data) => json.encode(data.toJson());

class Interes {
  Interes({
    required this.success,
    required this.message,
    required this.data,
  });

  int success;
  String message;
  List<Datum> data;

  factory Interes.fromJson(Map<String, dynamic> json) => Interes(
        success: json["success"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.titulo,
    required this.contenido,
    required this.img,
    required this.fechaInicio,
    required this.fechaFin,
    required this.idCat,
    required this.orden,
  });

  String id;
  String titulo;
  String contenido;
  String img;
  DateTime fechaInicio;
  DateTime fechaFin;
  String idCat;
  String orden;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["ID"],
        titulo: json["TITULO"],
        contenido: json["CONTENIDO"],
        img: json["IMG"],
        fechaInicio: DateTime.parse(json["FECHA_INICIO"]),
        fechaFin: DateTime.parse(json["FECHA_FIN"]),
        idCat: json["ID_CAT"],
        orden: json["ORDEN"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "TITULO": titulo,
        "CONTENIDO": contenido,
        "IMG": img,
        "FECHA_INICIO": fechaInicio.toIso8601String(),
        "FECHA_FIN": fechaFin.toIso8601String(),
        "ID_CAT": idCat,
        "ORDEN": orden,
      };
  String get fullUrl => 'https://portalempleado.um.edu.mx' + img;
}
