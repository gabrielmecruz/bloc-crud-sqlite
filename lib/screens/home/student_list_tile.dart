import 'package:flutter/material.dart';
import 'package:bloc_crud_sqlite/models/student.dart';
import 'package:bloc_crud_sqlite/screens/student/edit_screen.dart';

class StudentListTile extends StatefulWidget {
  const StudentListTile(this.student);

  final Student student;

  @override
  _StudentListTileState createState() => _StudentListTileState();
}

class _StudentListTileState extends State<StudentListTile> {
  String? studentLetter;
  String? studentActive;
  bool? isChecked = false;

  String getInitials(String studentName) => studentName.isNotEmpty
      ? studentName.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join()
      : '';
  String getRelationship(String rel) => rel == '1' ? 'Ativo' : 'Desativado';

  @override
  void initState() {
    studentActive = getRelationship(widget.student.active!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    studentLetter = getInitials(widget.student.name);
    return GestureDetector(
      onTap: () {
        studentActive == 'Ativo'
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    // o aluno existente eh enviada como parametro para a
                    // tela de edicao preencher os campos automaticamente
                    builder: (context) => StudentEditScreen(student: widget.student)),
              )
            : () {};
      },
      child: ListTile(
        tileColor: studentActive == 'Ativo' ? Colors.white : Colors.grey[300],
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 25,
          child: Text(
            '$studentLetter',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          widget.student.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$studentActive',
                style: const TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        trailing: Checkbox(
          value: isChecked,
          activeColor: Colors.blueGrey,
          shape: const CircleBorder(),
          onChanged: (newState) {
            setState(() {
              if (studentActive == 'Desativado') {
                newState = false;
                studentActive = 'Ativo';
              } else if (studentActive == 'Ativo') {
                newState = true;
                studentActive = 'Desativado';
              }
              isChecked = newState;
            });
          },
        ),
      ),
    );
  }
}
