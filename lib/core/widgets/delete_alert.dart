import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/Controller/home/home_bloc.dart';
import 'package:student_management/Controller/search/search_bloc.dart';
import 'package:student_management/core/widgets/snackbar.dart';

deleteDialog(BuildContext context, student,
    {bool search = false, bool details = false}) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Are you sure'),
      content:
          Text("Are yout sure you want to delete ${student.name}'s record"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            showSnackBar(Colors.red, 'Student deleteion failed', context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();

            BlocProvider.of<HomeBloc>(context)
                .add(DeleteStudent(student: student));
            if (search) {
              BlocProvider.of<SearchBloc>(context).add(GetAllData());
            }
            if (details) {
              Navigator.of(context).pop();
            }
            showSnackBar(Colors.green,
                "${student.name}'s data deleted succefully", context);
          },
          child: const Text('Yes'),
        ),
      ],
    ),
  );
}
