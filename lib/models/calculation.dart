import 'package:hive/hive.dart';

part 'calculation.g.dart';

@HiveType(typeId: 0)
class Calculation extends HiveObject{
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String email;

  @HiveField(2)
  late String equation;

  @HiveField(3)
  late String result;

  Calculation({
    required this.id,
    required this.email,
    required this.equation,
    required this.result
  });
}