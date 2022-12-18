part of 'details_bloc.dart';

@immutable
abstract class DetailsEvent {}

class GetDetails extends DetailsEvent {
  final int index;
  GetDetails({required this.index});
}
