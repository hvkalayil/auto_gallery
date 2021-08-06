import 'package:hive_flutter/hive_flutter.dart';

part 'image_model.g.dart';

@HiveType(typeId: 0)
class AutoImage {
  @HiveField(0)
  final DateTime dateTaken;

  @HiveField(1)
  final String path;

  AutoImage(this.dateTaken, this.path);
}
