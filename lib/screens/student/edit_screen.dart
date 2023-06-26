import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_crud_sqlite/cubits/student_cubit.dart';
import 'package:bloc_crud_sqlite/cubits/validation_cubit.dart';
import 'package:bloc_crud_sqlite/models/student.dart';

class StudentEditScreen extends StatelessWidget {
  const StudentEditScreen({Key? key, this.student}) : super(key: key);
  final Student? student;
  // o StudentCubit que foi criado e providenciado para o MaterialApp eh recuperado
  // via construtor .value, lembrando que novas instancias nao usam o .value,
  // somente as novas instancias de um cubit/bloc
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<StudentCubit>(context),
        ),
        BlocProvider(
          create: (context) => ValidationCubit(),
        ),
      ],
      child: StudentsEditView(student: student),
    );
  }
}

class StudentsEditView extends StatelessWidget {
  StudentsEditView({
    Key? key,
    this.student,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _paymentController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _paymentFocusNode = FocusNode();
  final Student? student;
  String titleScreen = '';

  @override
  Widget build(BuildContext context) {
    // se for edicao de um aluno existente, os campos do formulario
    // sao preenchidos com os atributos
    if (student == null) {
      _nameController.text = '';
      _emailController.text = '';
      _phoneController.text = '';
      _passwordController.text = '';
      _paymentController.text = '';
      titleScreen = 'Adicionar Aluno';
    } else {
      _nameController.text = student!.name;
      _emailController.text = student!.email;
      _phoneController.text = student!.phone;
      _paymentController.text = student!.payment.toString();
      _passwordController.text = student!.password;
      titleScreen = 'Editar Aluno';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(titleScreen),
        centerTitle: true,
      ),
      body: BlocListener<StudentCubit, StudentState>(
        listener: (context, state) {
          // a descricao dos estados esta no arquivo Students_state e os estados
          // nao tratados aqui sao utilizados na tela de lista
          // print(state.toString());
          if (state is StudentInitial) {
            const SizedBox();
          } else if (state is StudentLoading) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                });
          } else if (state is StudentSuccess) {
            Navigator.pop(context);
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text('Operação realizada com sucesso'),
              ));
            context.read<StudentCubit>().buscarAlunos();
          } else if (state is StudentLoaded) {
            Navigator.pop(context);
          } else if (state is StudentFailure) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text('Erro ao atualizar aluno'),
              ));
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BlocBuilder<ValidationCubit, ValidationState>(
                  builder: (context, state) {
                    return TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                      ),
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: _nameFocusNode.requestFocus,
                      onChanged: (text) {
                        // a validacao eh realizada em toda alteracao do campo
                        context.read<ValidationCubit>().validaForm(
                            _nameController.text,
                            _emailController.text,
                            _phoneController.text,
                            _paymentController.text,
                            _passwordController.text);
                      },
                      onFieldSubmitted: (String value) {},
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        // o estado StudentsValidating eh emitido quando ha erro de
                        // validacao em qualquer campo do formulario e
                        // a mensagem de erro tambem eh apresentada
                        if (state is Validating) {
                          if (state.nameMessage == '') {
                            return null;
                          } else {
                            return state.nameMessage;
                          }
                        }
                      },
                    );
                  },
                ),
                BlocBuilder<ValidationCubit, ValidationState>(
                  builder: (context, state) {
                    return TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                      ),
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      textInputAction: TextInputAction.done,
                      onChanged: (text) {
                        // a validacao eh realizada em toda alteracao do campo
                        context.read<ValidationCubit>().validaForm(
                            _nameController.text,
                            _emailController.text,
                            _phoneController.text,
                            _paymentController.text,
                            _passwordController.text);
                      },
                      onFieldSubmitted: (String value) {
                        if (_formKey.currentState!.validate()) {
                          //fechar teclado
                          FocusScope.of(context).unfocus();
                          context.read<StudentCubit>().salvarAluno(
                              student?.id,
                              _nameController.text,
                              _emailController.text,
                              _phoneController.text,
                              _passwordController.text,
                              double.parse(_paymentController.text),
                              student?.note);
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        // o estado StudentsValidating eh emitido quando ha erro de
                        // validacao em qualquer campo do formulario e
                        // a mensagem de erro tambem eh apresentada
                        if (state is Validating) {
                          if (state.emailMessage == '') {
                            return null;
                          } else {
                            return state.emailMessage;
                          }
                        }
                      },
                    );
                  },
                ),
                BlocBuilder<ValidationCubit, ValidationState>(
                  builder: (context, state) {
                    return TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                      ),
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      textInputAction: TextInputAction.done,
                      onChanged: (text) {
                        // a validacao eh realizada em toda alteracao do campo
                        context.read<ValidationCubit>().validaForm(
                            _nameController.text,
                            _emailController.text,
                            _phoneController.text,
                            _paymentController.text,
                            _passwordController.text);
                      },
                      onFieldSubmitted: (String value) {
                        if (_formKey.currentState!.validate()) {
                          //fechar teclado
                          FocusScope.of(context).unfocus();
                          context.read<StudentCubit>().salvarAluno(
                              student?.id,
                              _nameController.text,
                              _emailController.text,
                              _phoneController.text,
                              _passwordController.text,
                              double.parse(_paymentController.text),
                              student?.note);
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        // o estado StudentsValidating eh emitido quando ha erro de
                        // validacao em qualquer campo do formulario e
                        // a mensagem de erro tambem eh apresentada
                        if (state is Validating) {
                          if (state.passwordMessage == '') {
                            return null;
                          } else {
                            return state.passwordMessage;
                          }
                        }
                      },
                    );
                  },
                ),
                BlocBuilder<ValidationCubit, ValidationState>(
                  builder: (context, state) {
                    return TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Telefone',
                      ),
                      controller: _phoneController,
                      focusNode: _phoneFocusNode,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.phone,
                      onChanged: (text) {
                        // a validacao eh realizada em toda alteracao do campo
                        context.read<ValidationCubit>().validaForm(
                            _nameController.text,
                            _emailController.text,
                            _phoneController.text,
                            _paymentController.text,
                            _passwordController.text);
                      },
                      onFieldSubmitted: (String value) {
                        if (_formKey.currentState!.validate()) {
                          //fechar teclado
                          FocusScope.of(context).unfocus();
                          context.read<StudentCubit>().salvarAluno(
                              student?.id,
                              _nameController.text,
                              _emailController.text,
                              _phoneController.text,
                              _passwordController.text,
                              double.parse(_paymentController.text),
                              student?.note);
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        // o estado StudentsValidating eh emitido quando ha erro de
                        // validacao em qualquer campo do formulario e
                        // a mensagem de erro tambem eh apresentada
                        if (state is Validating) {
                          if (state.phoneMessage == '') {
                            return null;
                          } else {
                            return state.phoneMessage;
                          }
                        }
                      },
                    );
                  },
                ),
                BlocBuilder<ValidationCubit, ValidationState>(
                  builder: (context, state) {
                    return TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Valor da mensalidade',
                      ),
                      controller: _paymentController,
                      focusNode: _paymentFocusNode,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.phone,
                      onChanged: (text) {
                        // a validacao eh realizada em toda alteracao do campo
                        context.read<ValidationCubit>().validaForm(
                            _nameController.text,
                            _emailController.text,
                            _phoneController.text,
                            _paymentController.text,
                            _passwordController.text);
                      },
                      onFieldSubmitted: (String value) {
                        if (_formKey.currentState!.validate()) {
                          //fechar teclado
                          FocusScope.of(context).unfocus();
                          context.read<StudentCubit>().salvarAluno(
                              student?.id,
                              _nameController.text,
                              _emailController.text,
                              _phoneController.text,
                              _passwordController.text,
                              double.parse(_paymentController.text),
                              student?.note);
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        // o estado StudentsValidating eh emitido quando ha erro de
                        // validacao em qualquer campo do formulario e
                        // a mensagem de erro tambem eh apresentada
                        if (state is Validating) {
                          if (state.paymentMessage == '') {
                            return null;
                          } else {
                            return state.paymentMessage;
                          }
                        }
                      },
                    );
                  },
                ),
                BlocBuilder<ValidationCubit, ValidationState>(
                  builder: (context, state) {
                    return TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Observações',
                      ),
                      textInputAction: TextInputAction.done,
                      onChanged: (text) {
                        // a validacao eh realizada em toda alteracao do campo
                        context.read<ValidationCubit>().validaForm(
                            _nameController.text,
                            _emailController.text,
                            _phoneController.text,
                            _paymentController.text,
                            _passwordController.text);
                      },
                      onFieldSubmitted: (String value) {},
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: BlocBuilder<ValidationCubit, ValidationState>(
                          builder: (context, state) {
                            // o botao de salvar eh habilitado somente quando
                            // o formulario eh completamente validado
                            return ElevatedButton(
                              onPressed: state is Validated
                                  ? () {
                                      if (_formKey.currentState!.validate()) {
                                        //fechar teclado
                                        FocusScope.of(context).unfocus();
                                        context.read<StudentCubit>().salvarAluno(
                                              student?.id,
                                              _nameController.text,
                                              _emailController.text,
                                              _phoneController.text,
                                              _passwordController.text,
                                              double.parse(_paymentController.text),
                                              student?.note,
                                            );
                                      }
                                    }
                                  : null,
                              child: const Text('Salvar'),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: BlocBuilder<ValidationCubit, ValidationState>(
                          builder: (context, state) {
                            return ElevatedButton(
                                onPressed: () {
                                  // excluir atraves do id
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Excluir Cadastro'),
                                      content: const Text('Confirmar operação?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            context
                                                .read<StudentCubit>()
                                                .excluirAluno(student?.id);
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(const SnackBar(
                                                content:
                                                    Text('Aluno excluído com sucesso'),
                                              ));
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Excluir',
                                        style: TextStyle(color: Colors.indigo)),
                                    Icon(Icons.delete, color: Colors.indigo),
                                  ],
                                ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
