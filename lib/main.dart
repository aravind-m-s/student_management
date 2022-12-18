import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:student_management/Controller/add/add_bloc.dart';
import 'package:student_management/Controller/details/details_bloc.dart';
import 'package:student_management/Controller/edit/edit_bloc.dart';
import 'package:student_management/Controller/home/home_bloc.dart';
import 'package:student_management/Controller/search/search_bloc.dart';
import 'package:student_management/Model/student_model.dart';
import 'package:student_management/View/screen_add/screen_add.dart';
import 'package:student_management/View/screen_home/screen_home.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(StudentModelAdapter().typeId)) {
    Hive.registerAdapter(StudentModelAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) => AddBloc(),
        ),
        BlocProvider(
          create: (context) => SearchBloc(),
        ),
        BlocProvider(
          create: (context) => DetailsBloc(),
        ),
        BlocProvider(
          create: (context) => EditBloc(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ScreenHome(),
      ),
    );
  }
}
