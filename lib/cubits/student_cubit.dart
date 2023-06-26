import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_crud_sqlite/database/db.dart';
import 'package:bloc_crud_sqlite/models/student.dart';

part 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  StudentCubit({required DatabaseProvider databaseProvider})
      : _databaseProvider = databaseProvider,
        super(const StudentInitial());

  //instancia do banco de dados sqlite
  final DatabaseProvider _databaseProvider;

  String search = '';

  Future<void> buscarAlunos() async {
    emit(const StudentLoading());
    try {
      final students = await _databaseProvider.listStudents();
      emit(StudentLoaded(
        student: students,
      ));
    } on Exception {
      emit(const StudentFailure());
      rethrow;
    }
  }

  void filtrarPorNome(List<Student> students) {
    emit(const StudentLoading());
    try {
      students = _databaseProvider.filteredStudentsByName;
      emit(StudentLoaded(
        student: students,
      ));
    } on Exception {
      emit(const StudentFailure());
    }
  }

  void filtrarPorAtivo() {
    emit(const StudentLoading());
    try {
      final students = _databaseProvider.filteredStudentsByRel;
      emit(StudentLoaded(
        student: students,
      ));
    } on Exception {
      emit(const StudentFailure());
    }
  }

  Future<void> excluirAluno(id) async {
    emit(const StudentLoading());

    await Future.delayed(const Duration(seconds: 2));
    try {
      await _databaseProvider.delete(id);
      buscarAlunos();
    } on Exception {
      emit(const StudentFailure());
    }
  }

  Future<void> excluirAlunos() async {
    emit(const StudentLoading());

    await Future.delayed(const Duration(seconds: 2));
    try {
      await _databaseProvider.deleteAll();
      emit(const StudentLoaded(
        student: [],
      ));
    } on Exception {
      emit(const StudentFailure());
    }
  }

  Future<void> salvarAluno(int? id, String nome, String email, String tel, String senha,
      num valor, String? notas) async {
    Student editStudent = Student(
        id: id,
        email: email,
        name: nome,
        phone: tel,
        password: senha,
        payment: valor,
        note: notas);
    emit(const StudentLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      //se o metodo nao recebeu um id op aluno sera incluido, caso contrario
      //o aluno existente sera atualizada pelo id
      if (id == null) {
        editStudent = await _databaseProvider.save(editStudent);
      } else {
        editStudent = await _databaseProvider.update(editStudent);
      }
      emit(const StudentSuccess());
    } on Exception {
      emit(const StudentFailure());
      rethrow;
    }
  }
}
