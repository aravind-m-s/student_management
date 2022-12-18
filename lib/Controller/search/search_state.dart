part of 'search_bloc.dart';

class SearchState {
  final List<StudentModel> studendtList;
  SearchState({required this.studendtList});
}

class SearchInitial extends SearchState {
  SearchInitial() : super(studendtList: const []);
}
