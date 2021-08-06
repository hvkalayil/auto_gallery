// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AutoImageAdapter extends TypeAdapter<AutoImage> {
  @override
  final int typeId = 0;

  @override
  AutoImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AutoImage(
      fields[0] as DateTime,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AutoImage obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.dateTaken)
      ..writeByte(1)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AutoImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
