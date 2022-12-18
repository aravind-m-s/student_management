// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';
import 'package:student_management/Model/student_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<GetAllStudents>((event, emit) async {
      final studentDB = await Hive.openBox<StudentModel>('student');
      final list = studentDB.values.toList();
      emit(HomeState(studentList: list));
    });
    on<DeleteStudent>((event, emit) async {
      final studentDB = await Hive.openBox<StudentModel>('student');
      final index = studentDB.values.toList().indexOf(event.student);
      studentDB.deleteAt(index);
      final list = studentDB.values.toList();
      emit(HomeState(studentList: list));
    });
  }
}
