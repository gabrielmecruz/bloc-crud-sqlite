part of 'student_cubit.dart';

abstract class StudentState {
  const StudentState();
}

// estado da tela inicial
class StudentInitial extends StudentState {
  const StudentInitial();

  @override
  List<Object?> get props => [];
}

// aguardando operacao ser realizada
class StudentLoading extends StudentState {
  const StudentLoading();

  @override
  List<Object?> get props => [];
}

// lista carregada
class StudentLoaded extends StudentState {
  const StudentLoaded({
    this.student,
  });

  final List<Student>? student;

  StudentLoaded copyWith({
    List<Student>? students,
  }) {
    return StudentLoaded(
      student: students ?? student,
    );
  }

  @override
  List<Object?> get props => [student];
}

// falha ao realizar operacao
class StudentFailure extends StudentState {
  const StudentFailure();

  @override
  List<Object?> get props => [];
}

// operacao realizada com sucesso
class StudentSuccess extends StudentState {
  const StudentSuccess();

  @override
  List<Object?> get props => [];
}
