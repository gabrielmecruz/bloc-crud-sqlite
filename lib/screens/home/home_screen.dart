import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_crud_sqlite/cubits/student_cubit.dart';
import 'package:bloc_crud_sqlite/models/student.dart';
import 'package:bloc_crud_sqlite/screens/home/student_list_tile.dart';
import 'package:bloc_crud_sqlite/screens/student/edit_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // o StudentsCubit que foi criado e providenciado para o MaterialApp eh recuperado
  // via construtor .value e executa a funcao de buscar,
  // ou seja, novas instancias nao usam o .value, instancias existentes sim
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<StudentCubit>(context)..buscarAlunos(),
      child: const DocumentosView(),
    );
  }
}

class DocumentosView extends StatelessWidget {
  const DocumentosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD - Lista de Alunos'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              // excluir tudo
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Excluir os alunos'),
                  content: const Text('Confirmar operação?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<StudentCubit>().excluirAlunos();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(const SnackBar(
                            content: Text('Alunos excluídos com sucesso'),
                          ));
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: const _Content(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          // na tela de edicao
          //
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const StudentEditScreen(student: null)),
          );
          //
        },
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudentCubit>().state;
    // a descricao dos estados esta no arquivo Students_state
    // os estados nao tratados aqui sao utilizados na tela de edicao
    // print('Studentlist ' + state.toString());
    if (state is StudentInitial) {
      return const SizedBox();
    } else if (state is StudentLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    } else if (state is StudentLoaded) {
      //a mensagem abaixo aparece se a lista estiver vazia
      if (state.student!.isEmpty) {
        return const Center(
          child: Text('Não há alunos cadastrados.'),
        );
      } else {
        return _StudentsList(state.student);
      }
    } else {
      return const Center(
        child: Text('Erro ao recuperar base de dados.'),
      );
    }
  }
}

class _StudentsList extends StatelessWidget {
  const _StudentsList(this.students, {Key? key}) : super(key: key);
  final List<Student>? students;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: students!.length,
            itemBuilder: (_, element) {
              return Column(
                children: [
                  StudentListTile(students![element]),
                  const Divider(
                    indent: 10,
                    thickness: 2,
                  )
                ],
              );
            }, // optional
          ),
        ],
      ),
    );
  }
}
