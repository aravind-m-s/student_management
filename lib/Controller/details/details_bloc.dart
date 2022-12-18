import 'package:bloc/bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';
import 'package:student_management/Model/student_model.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  DetailsBloc() : super(DetailsInitial()) {
    on<GetDetails>((event, emit) async {
      final studentDB = await Hive.openBox<StudentModel>('student');
      final student = studentDB.values.elementAt(event.index);
      emit(DetailsState(student: student));
    });
  }
}
