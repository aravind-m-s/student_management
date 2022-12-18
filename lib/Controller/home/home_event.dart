part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class GetAllStudents extends HomeEvent {}

class DeleteStudent extends HomeEvent {
  final StudentModel student;
  DeleteStudent({required this.student});
}
