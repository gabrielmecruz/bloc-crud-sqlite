part of 'validation_cubit.dart';

abstract class ValidationState extends Equatable {
  const ValidationState();
}

// campos do formulario aguardando validacao com sucesso
class Validating extends ValidationState {
  const Validating({
    this.nameMessage,
    this.emailMessage,
    this.phoneMessage,
    this.paymentMessage,
    this.passwordMessage,
  });

  final String? nameMessage;
  final String? emailMessage;
  final String? phoneMessage;
  final String? paymentMessage;
  final String? passwordMessage;

  Validating copyWith(
      {String? nameMessage,
      String? emailMessage,
      String? phoneMessage,
      String? paymentMessage,
      String? passwordMessage}) {
    return Validating(
      nameMessage: nameMessage ?? this.nameMessage,
      emailMessage: emailMessage ?? this.emailMessage,
      phoneMessage: phoneMessage ?? this.phoneMessage,
      paymentMessage: paymentMessage ?? this.paymentMessage,
      passwordMessage: passwordMessage ?? this.passwordMessage,
    );
  }

  @override
  List<Object?> get props => [
        nameMessage,
        emailMessage,
        phoneMessage,
        paymentMessage,
        passwordMessage,
      ];
}

// campos do formulario validados com sucesso
class Validated extends ValidationState {
  const Validated();

  @override
  List<Object> get props => [];
}
