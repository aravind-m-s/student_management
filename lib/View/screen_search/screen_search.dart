import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/Controller/search/search_bloc.dart';
import 'package:student_management/View/screen_search/widgets/search_card.dart';

class ScreenSearch extends StatelessWidget {
  const ScreenSearch({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => BlocProvider.of<SearchBloc>(context).add(GetAllData()),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                label: const Text("Search"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onChanged: (value) => BlocProvider.of<SearchBloc>(context)
                  .add(GetSearchResult(query: value)),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state.studendtList.isEmpty) {
                  return const Center(
                    child: Text('No Students Found'),
                  );
                }
                return ListView.separated(
                  itemBuilder: (context, index) {
                    final student = state.studendtList[index];
                    return SearchCard(student: student);
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: state.studendtList.length,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
