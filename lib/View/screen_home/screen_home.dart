import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/Controller/home/home_bloc.dart';
import 'package:student_management/View/screen_add/screen_add.dart';
import 'package:student_management/View/screen_home/widgets/main_card.dart';
import 'package:student_management/View/screen_search/screen_search.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<HomeBloc>(context).add(GetAllStudents());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => const ScreenSearch(),
              ));
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.studentList.isEmpty) {
              return const Center(
                child: Text(
                  'No Students Found',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              );
            }
            return ListView.separated(
              itemCount: state.studentList.length,
              itemBuilder: (context, index) {
                final student = state.studentList[index];
                return MainCard(
                  student: student,
                  index: index,
                );
              },
              separatorBuilder: ((context, index) => const Divider()),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const ScreenAddStudent(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
