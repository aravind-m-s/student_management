import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/Controller/details/details_bloc.dart';
import 'package:student_management/View/screen_edit/screen_edit.dart';
import 'package:student_management/core/constants.dart';
import 'package:student_management/core/widgets/delete_alert.dart';

class ScreenViewStudent extends StatelessWidget {
  final int index;
  const ScreenViewStudent({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<DetailsBloc>(context).add(GetDetails(index: index));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Center(
        child: BlocBuilder<DetailsBloc, DetailsState>(
          builder: (context, state) {
            if (state.student == null) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: FileImage(File(state.student!.file)),
                ),
                const SizedBox(height: 50),
                textWidget("Name : ${state.student!.name}"),
                kHeight10,
                textWidget("Class : ${state.student!.grade}"),
                kHeight10,
                textWidget("Division : ${state.student!.division}"),
                kHeight10,
                textWidget("Age : ${state.student!.age}"),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ScreenEdit(
                              index: index,
                              student: state.student!,
                            ),
                          ));
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.delete),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        label: const Text('Delete'),
                        onPressed: () {
                          deleteDialog(context, state.student!, details: true);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Text textWidget(String text) =>
      Text(text, style: const TextStyle(fontSize: 30));
}
