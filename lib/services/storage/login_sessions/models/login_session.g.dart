// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoginSessionAdapter extends TypeAdapter<LoginSession> {
  @override
  final int typeId = 0;

  @override
  LoginSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginSession(
      userId: fields[0] as String,
      name: fields[1] as String,
      image: fields[2] as String?,
      activeLogin: fields[4] as bool,
      authCredentials: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LoginSession obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.authCredentials)
      ..writeByte(4)
      ..write(obj.activeLogin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
