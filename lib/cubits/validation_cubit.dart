import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'validation_state.dart';

class ValidationCubit extends Cubit<ValidationState> {
  ValidationCubit() : super(const Validating());

  //validar formulario de edicao
  void validaForm(String nome, String email, String tel, String valor, String senha) {
    String cubitNameMessage = '';
    String cubitEmailMessage = '';
    String cubitPhoneMessage = '';
    String cubitPaymentMessage = '';
    String cubitPasswordMessage = '';
    bool formInvalid;

    formInvalid = false;
    if (nome == '') {
      formInvalid = true;
      cubitNameMessage = 'Preencha o nome';
    } else {
      cubitNameMessage = '';
    }
    if (email == '') {
      formInvalid = true;
      cubitEmailMessage = 'Preencha o email';
    } else {
      cubitEmailMessage = '';
    }
    if (tel == '') {
      formInvalid = true;
      cubitPhoneMessage = 'Preencha o telefone';
    } else {
      cubitPhoneMessage = '';
    }
    if (valor == '') {
      formInvalid = true;
      cubitPaymentMessage = 'Preencha o valor da mensalidade';
    } else {
      cubitPaymentMessage = '';
    }
    if (senha == '') {
      formInvalid = true;
      cubitPasswordMessage = 'Preencha a senha';
    } else {
      cubitPasswordMessage = '';
    }

    if (formInvalid == true) {
      emit(Validating(
          nameMessage: cubitNameMessage,
          emailMessage: cubitEmailMessage,
          phoneMessage: cubitPhoneMessage,
          paymentMessage: cubitPaymentMessage,
          passwordMessage: cubitPasswordMessage));
    } else {
      emit(const Validated());
    }
  }
}
