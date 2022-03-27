// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalculationAdapter extends TypeAdapter<Calculation> {
  @override
  final int typeId = 0;

  @override
  Calculation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Calculation(
      id: fields[0] as String,
      email: fields[1] as String,
      equation: fields[2] as String,
      result: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Calculation obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.equation)
      ..writeByte(3)
      ..write(obj.result);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalculationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
