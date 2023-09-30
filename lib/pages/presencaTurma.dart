import 'package:flutter/material.dart';

import '../models/aluno.dart';
import '../models/turma.dart';

class PresencaTurma extends StatefulWidget {
  final Turma turma;

  PresencaTurma({required this.turma});

  @override
  _PresencaTurmaState createState() => _PresencaTurmaState();
}

class _PresencaTurmaState extends State<PresencaTurma> {
  List<Aluno> alunos = [
    Aluno(nome: 'Aluno 1', matricula: '12345', presente: false),
    Aluno(nome: 'Aluno 2', matricula: '67890', presente: true),
    Aluno(nome: 'Aluno 3', matricula: '54321', presente: false),
    Aluno(nome: 'Aluno 4', matricula: '98765', presente: true),
    Aluno(nome: 'Aluno 5', matricula: '11111', presente: false),
    Aluno(nome: 'Aluno 6', matricula: '22222', presente: true),
    Aluno(nome: 'Aluno 7', matricula: '33333', presente: false),
    Aluno(nome: 'Aluno 8', matricula: '44444', presente: true),
    Aluno(nome: 'Aluno 9', matricula: '55555', presente: false),
    Aluno(nome: 'Aluno 10', matricula: '66666', presente: true),
    Aluno(nome: 'Aluno 11', matricula: '77777', presente: false),
    Aluno(nome: 'Aluno 12', matricula: '88888', presente: true),
    Aluno(nome: 'Aluno 13', matricula: '99999', presente: false),
    Aluno(nome: 'Aluno 14', matricula: '10101', presente: true),
    Aluno(nome: 'Aluno 15', matricula: '20202', presente: false),
    Aluno(nome: 'Aluno 16', matricula: '30303', presente: true),
    Aluno(nome: 'Aluno 17', matricula: '40404', presente: false),
    Aluno(nome: 'Aluno 18', matricula: '50505', presente: true),
    Aluno(nome: 'Aluno 19', matricula: '60606', presente: false),
    Aluno(nome: 'Aluno 20', matricula: '70707', presente: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.turma.disciplina),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: alunos.length,
              itemBuilder: (context, index) {
                Aluno aluno = alunos[index];

                return ListTile(
                  title: Text(aluno.nome),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Matrícula: ${aluno.matricula}'),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // Toggle de presente/ausente
                        aluno.presente = !aluno.presente;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: aluno.presente ? Colors.green : Colors.red,
                    ),
                    child: Text(aluno.presente ? 'Presente' : 'Ausente'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}