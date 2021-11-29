// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionnaireResponseAdapter extends TypeAdapter<QuestionnaireResponse> {
  @override
  final int typeId = 1;

  @override
  QuestionnaireResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuestionnaireResponse(
      qr: (fields[0] as List).cast<int>(),
      userImage: fields[1] as String,
      name: fields[2] as String,
      department: fields[5] as String,
      strRole: fields[3] as String,
      strResidence: fields[4] as String,
      strReason: fields[6] as String,
    )..dateFilled = fields[7] as DateTime;
  }

  @override
  void write(BinaryWriter writer, QuestionnaireResponse obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.qr)
      ..writeByte(1)
      ..write(obj.userImage)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.strRole)
      ..writeByte(4)
      ..write(obj.strResidence)
      ..writeByte(5)
      ..write(obj.department)
      ..writeByte(6)
      ..write(obj.strReason)
      ..writeByte(7)
      ..write(obj.dateFilled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionnaireResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
