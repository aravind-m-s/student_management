import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:student_management/Controller/edit/edit_bloc.dart';
import 'package:student_management/Controller/home/home_bloc.dart';
import 'package:student_management/Model/student_model.dart';
import 'package:student_management/core/constants.dart';
import 'package:student_management/core/widgets/snackbar.dart';

final TextEditingController name = TextEditingController();
final TextEditingController grade = TextEditingController();
final TextEditingController division = TextEditingController();
final TextEditingController age = TextEditingController();

String image = '';

class ScreenEdit extends StatelessWidget {
  final int index;
  final StudentModel student;

  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  const ScreenEdit({super.key, required this.index, required this.student});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<EditBloc>(context).add(EditImage(image: student.file));

    image = student.file;

    name.text = student.name;
    grade.text = student.grade.toString();
    division.text = student.division;
    age.text = student.age.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student'),
      ),
      body: Center(
        child: ListView(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  imageWidget(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(height: 30),
                        textField("Name", name),
                        kHeight10,
                        textField("Class", grade),
                        kHeight10,
                        textField("Division", division),
                        kHeight10,
                        textField("Age", age),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.cancel),
                        label: const Text('Cancel'),
                      ),
                      submitButton(context)
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton submitButton(context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.edit),
      onPressed: () {
        final form = formKey.currentState!;
        if (form.validate()) {
          final student = StudentModel(
              name: name.text,
              grade: int.parse(grade.text),
              division: division.text,
              age: int.parse(age.text),
              file: image);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Are you sure'),
              content: Text("Do you want to edit ${name.text}'s record"),
              actions: [
                TextButton(
                  onPressed: () {
                    int count = 0;
                    BlocProvider.of<EditBloc>(context)
                        .add(EditStudent(student: student, index: index));
                    BlocProvider.of<HomeBloc>(context).add(GetAllStudents());
                    Navigator.of(context).popUntil(
                      (route) => count++ == 2,
                    );

                    showSnackBar(
                        Colors.green, "Student edited succefully", context);
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    showSnackBar(Colors.red, "Student edit failed", context);
                  },
                  child: Text('No'),
                ),
              ],
            ),
          );
        }
      },
      label: const Text('Edit Student'),
    );
  }

  imageWidget(context) {
    return BlocBuilder<EditBloc, EditState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            editDialog(context);
          },
          child: CircleAvatar(
            radius: 75,
            backgroundImage: FileImage(File(image)),
          ),
        );
      },
    );
  }

  editDialog(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return LimitedBox(
          maxHeight: 200,
          child: AlertDialog(
            title: const Text('Edit Image'),
            content: const Text('Please choose Image source'),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  image = await setImage(ImageSource.gallery, context);
                  postButtonClick(context);
                },
                child: const Text('Gallery'),
              ),
              ElevatedButton(
                onPressed: () async {
                  image = await setImage(ImageSource.camera, context);
                  postButtonClick(context);
                },
                child: const Text('Camera'),
              ),
            ],
          ),
        );
      },
    );
  }

  postButtonClick(context) {
    BlocProvider.of<EditBloc>(context).add(EditImage(image: image));
    Navigator.of(context).pop();
  }

  setImage(source, context) async {
    final image = await ImagePicker().pickImage(source: source);
    final directory = await getApplicationDocumentsDirectory();
    if (image == null) return;
    final name = basename(image.path);
    final img = File('${directory.path}/$name');

    final file = await File(image.path).copy(img.path);

    return file.path;
  }

  TextFormField textField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        label: Text(label),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      validator: (value) {
        return (value == null || value.isEmpty)
            ? 'Field cannot be empty'
            : null;
      },
    );
  }
}
