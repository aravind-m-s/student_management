import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:student_management/Controller/add/add_bloc.dart';
import 'package:student_management/Controller/home/home_bloc.dart';
import 'package:student_management/Model/student_model.dart';
import 'package:student_management/core/constants.dart';
import 'package:student_management/core/widgets/snackbar.dart';

String image = '';

class ScreenAddStudent extends StatelessWidget {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  const ScreenAddStudent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AddBloc>(context).add(AddImage(image: ''));
    image = '';
    final TextEditingController nameController = TextEditingController();
    final TextEditingController gradeController = TextEditingController();
    final TextEditingController divisionController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
      ),
      body: Center(
        child: ListView(
          children: [
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  ImageWidget(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(height: 30),
                        nameField(nameController),
                        kHeight10,
                        classField(gradeController),
                        kHeight10,
                        divisionField(divisionController),
                        kHeight10,
                        ageField(ageController),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  submitButton(nameController, gradeController,
                      divisionController, ageController, context)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField ageField(ageController) {
    return TextFormField(
      controller: ageController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: const Text("Age"),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      validator: (value) {
        return (value == null || value.isEmpty) ? 'Age cannot be empty' : null;
      },
    );
  }

  TextFormField divisionField(divisionController) {
    return TextFormField(
      controller: divisionController,
      decoration: InputDecoration(
        label: const Text('Division'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      validator: (value) {
        return (value == null || value.isEmpty)
            ? 'Division cannot be empty'
            : null;
      },
    );
  }

  TextFormField classField(TextEditingController gradeController) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: gradeController,
      decoration: InputDecoration(
        label: const Text('Class'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      validator: (value) {
        return (value == null || value.isEmpty)
            ? 'Class cannot be empty'
            : null;
      },
    );
  }

  TextFormField nameField(TextEditingController nameController) {
    return TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          label: const Text('Name'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        validator: (value) {
          return (value == null || value.isEmpty)
              ? 'Name cannot be empty'
              : null;
        });
  }

  imageWidget(context) {
    final addBloc = AddBloc();
    final size = MediaQuery.of(context).size;
    return BlocBuilder<AddBloc, AddState>(
      bloc: addBloc,
      builder: (cxt, state) {
        if (state.image == '') {
          return Container(
            height: size.height / 4,
            width: size.width - 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(
                  Icons.camera,
                  size: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    imageButton('Gallery', ImageSource.gallery, context),
                    imageButton('Camera', ImageSource.camera, context),
                  ],
                )
              ],
            ),
          );
        } else {
          return Container(
            child: CircleAvatar(
              radius: 100,
              backgroundImage: FileImage(File(image)),
            ),
          );
        }
      },
    );
  }

  ElevatedButton submitButton(
      TextEditingController name,
      TextEditingController grade,
      TextEditingController division,
      TextEditingController age,
      BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          final form = formKey.currentState!;
          if (form.validate()) {
            if (image != '') {
              final value = StudentModel(
                name: name.text,
                grade: int.parse(grade.text),
                division: division.text,
                age: int.parse(age.text),
                file: image,
              );
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Are you sure!'),
                  content: const Text('Do you want to add this record'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        showSnackBar(
                            Colors.red, 'Student adding failed', context);
                      },
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        addToDb(value);
                        BlocProvider.of<HomeBloc>(context)
                            .add(GetAllStudents());
                        int count = 0;
                        Navigator.of(context).popUntil((route) => count++ == 2);
                        showSnackBar(
                            Colors.green, 'Student added succefully', context);
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Oops!'),
                  content: const Text('Image cannot be empty'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'))
                  ],
                ),
              );
            }
          }
        },
        child: const Text('Add Student'));
  }

  addToDb(value) async {
    final studentDb = await Hive.openBox<StudentModel>('student');
    studentDb.add(value);
  }
}

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<AddBloc, AddState>(
      builder: (ctx, state) {
        if (state.image == '') {
          return Container(
            height: size.height / 4,
            width: size.width - 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(
                  Icons.camera,
                  size: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    imageButton('Gallery', ImageSource.gallery, context),
                    imageButton('Camera', ImageSource.camera, context),
                  ],
                )
              ],
            ),
          );
        } else {
          return Container(
            width: 210,
            height: 210,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: FileImage(File(image)),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        BlocProvider.of<AddBloc>(context)
                            .add(AddImage(image: ''));
                      },
                    ))
              ],
            ),
          );
        }
      },
    );
  }
}

SizedBox imageButton(location, source, context) {
  return SizedBox(
    width: 150,
    height: 50,
    child: ElevatedButton(
      child: Text('From $location'),
      onPressed: () async {
        image = await setImage(source, context);
        BlocProvider.of<AddBloc>(context).add(AddImage(image: image));
      },
    ),
  );
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
