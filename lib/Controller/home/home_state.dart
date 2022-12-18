part of 'home_bloc.dart';

class HomeState {
  final List<StudentModel> studentList;

  HomeState({required this.studentList});
}

class HomeInitial extends HomeState {
  HomeInitial() : super(studentList: []);
}
