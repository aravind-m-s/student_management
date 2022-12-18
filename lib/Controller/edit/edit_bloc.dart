import 'package:bloc/bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';
import 'package:student_management/Model/student_model.dart';

part 'edit_event.dart';
part 'edit_state.dart';

class EditBloc extends Bloc<EditEvent, EditState> {
  EditBloc() : super(EditInitial()) {
    on<EditStudent>((event, emit) async {
      final studentDb = await Hive.openBox<StudentModel>('student');
      studentDb.putAt(event.index, event.student);
    });
    on<EditImage>(
      (event, emit) {
        final image = EditImageState(image: event.image);
        emit(image);
      },
    );
  }
}
