part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class GetAllData extends SearchEvent {}

class GetSearchResult extends SearchEvent {
  final String query;
  GetSearchResult({required this.query});
}
