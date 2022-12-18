part of 'add_bloc.dart';

@immutable
abstract class AddEvent {}

class AddStudent extends AddEvent {
  final StudentModel student;
  AddStudent({required this.student});
}

class AddImage extends AddEvent {
  final String image;

  AddImage({required this.image});
}
