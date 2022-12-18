import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/Controller/home/home_bloc.dart';
import 'package:student_management/Model/student_model.dart';
import 'package:student_management/View/screen_edit/screen_edit.dart';
import 'package:student_management/View/screen_view_student/screen_details.dart';
import 'package:student_management/core/widgets/delete_alert.dart';

class MainCard extends StatelessWidget {
  final StudentModel student;
  final int index;
  const MainCard({super.key, required this.student, required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ScreenViewStudent(
              index: index,
            ),
          ),
        );
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 4,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: FileImage(File(student.file)),
            ),
            Text(student.name),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 50,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => ScreenEdit(
                            index: index,
                            student: student,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 50,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.delete),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    label: const Text('Delete'),
                    onPressed: () {
                      deleteDialog(context, student);
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
