part of 'edit_bloc.dart';

@immutable
abstract class EditEvent {}

class EditStudent extends EditEvent {
  final StudentModel student;
  final int index;
  EditStudent({required this.student, required this.index});
}

class EditImage extends EditEvent {
  final String image;
  EditImage({this.image = ''});
}
