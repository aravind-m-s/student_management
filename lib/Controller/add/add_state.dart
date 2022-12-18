part of 'add_bloc.dart';

class AddState {
  final String image;
  AddState({required this.image});
}

class AddInitial extends AddState {
  AddInitial() : super(image: '');
}
