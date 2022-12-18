part of 'details_bloc.dart';

class DetailsState {
  StudentModel? student =
      StudentModel(name: '', grade: 0, division: '', age: 0, file: '');
  DetailsState({this.student});
}

class DetailsInitial extends DetailsState {}
