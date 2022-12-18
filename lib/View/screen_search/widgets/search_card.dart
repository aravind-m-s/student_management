import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:student_management/Model/student_model.dart';
import 'package:student_management/View/screen_view_student/screen_details.dart';
import 'package:student_management/core/widgets/delete_alert.dart';

class SearchCard extends StatelessWidget {
  final StudentModel student;
  const SearchCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final index = await indexFinder(student);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ScreenViewStudent(index: index),
          ),
        );
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: FileImage(File(student.file)),
            ),
            details(),
            deleteButton(context, student.name),
          ],
        ),
      ),
    );
  }

  IconButton deleteButton(context, name) {
    return IconButton(
      onPressed: () {
        deleteDialog(context, student, search: true);
      },
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
    );
  }

  Column details() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(student.name),
        Text(student.grade.toString() + student.division),
      ],
    );
  }

  indexFinder(StudentModel student) async {
    final sdb = await Hive.openBox<StudentModel>('student');
    final index = sdb.values.toList().indexOf(student);
    return index;
  }
}
