import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';
import 'package:student_management/Model/student_model.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<GetAllData>((event, emit) async {
      final studentDB = await Hive.openBox<StudentModel>('student');
      final list = studentDB.values.toList();
      emit(SearchState(studendtList: list));
    });
    on<GetSearchResult>((event, emit) async {
      final studentDB = await Hive.openBox<StudentModel>('student');
      final list = studentDB.values.toList();
      final searchResult =
          list.where((element) => element.name.contains(event.query)).toList();
      emit(SearchState(studendtList: searchResult));
    });
  }
}
