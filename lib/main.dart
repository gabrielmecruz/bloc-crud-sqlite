import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_crud_sqlite/cubits/student_cubit.dart';
import 'package:bloc_crud_sqlite/database/db.dart';
import 'package:bloc_crud_sqlite/screens/base_screen.dart';
import 'package:bloc_crud_sqlite/screens/home/home_screen.dart';
import 'package:bloc_crud_sqlite/screens/student/edit_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => DatabaseProvider.instace,
      child: BlocProvider(
        create: (context) => StudentCubit(databaseProvider: DatabaseProvider.instace),
        child: MaterialApp(
          home: const HomeScreen(),
          debugShowCheckedModeBanner: false,
          title: 'CRUD SQLite',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
          ),
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/student':
                return MaterialPageRoute(
                  builder: (_) => const StudentEditScreen(),
                );
              case '/':
              default:
                return MaterialPageRoute(
                  builder: (_) => const BaseScreen(),
                );
            }
          },
        ),
      ),
    );
  }
}
