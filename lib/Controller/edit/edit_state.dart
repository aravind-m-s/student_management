part of 'edit_bloc.dart';

@immutable
abstract class EditState {
  final StudentModel? student;
  final String? image;
  const EditState({this.student, this.image});
}

class EditInitial extends EditState {}

class EditImageState extends EditState {
  EditImageState({required super.image});
}
