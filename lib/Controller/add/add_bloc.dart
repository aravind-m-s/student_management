import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';
import 'package:student_management/Model/student_model.dart';

part 'add_event.dart';
part 'add_state.dart';

class AddBloc extends Bloc<AddEvent, AddState> {
  AddBloc() : super(AddInitial()) {
    on<AddStudent>((event, emit) async {
      final studentDB = await Hive.openBox<StudentModel>('student');
      if (event.student.name != '') {
        studentDB.add(event.student);
      }
    });
    on<AddImage>((event, emit) {
      final image = AddState(image: event.image);
      emit(image);
    });
  }
}
