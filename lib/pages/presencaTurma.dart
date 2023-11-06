import 'package:chamadainteligente/models/usuario.dart';
import 'package:flutter/material.dart';

import '../models/turma.dart';

class PresencaTurma extends StatefulWidget {
  final Turma turma;

  PresencaTurma({required this.turma});

  @override
  _PresencaTurmaState createState() => _PresencaTurmaState();
}

class _PresencaTurmaState extends State<PresencaTurma> {
  List<Usuario> alunos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.turma.titulo),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: alunos.length,
              itemBuilder: (context, index) {
                Usuario aluno = alunos[index];

                return ListTile(
                  title: Text(aluno.nome),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Matrícula: ${aluno.matricula}'),
                    ],
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