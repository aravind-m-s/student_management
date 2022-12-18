import 'package:hive_flutter/adapters.dart';
part 'student_model.g.dart';

@HiveType(typeId: 0)
class StudentModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final int grade;
  @HiveField(2)
  final String division;
  @HiveField(3)
  final int age;
  @HiveField(4)
  final String file;

  StudentModel({
    required this.name,
    required this.grade,
    required this.division,
    required this.age,
    required this.file,
  });
}
