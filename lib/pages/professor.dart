import 'package:chamadainteligente/models/professor.dart';
import 'package:flutter/material.dart';

import '../models/turma.dart';
import 'presencaTurma.dart';

class ProfessorPage extends StatelessWidget {
  final Professor usuario;
  final List<Turma> turmas = [
    Turma(
      disciplina: 'Gerência de Projeto',
      codigoDisciplina: 'GER101',
      curso: 'Sistemas de Informação',
    ),
    Turma(
      disciplina: 'Desenvolvimento Web',
      codigoDisciplina: 'DES201',
      curso: 'Sistemas de Informação',
    ),
  ];

  ProfessorPage({required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Turmas'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Usuário logado: ${usuario.email}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: turmas.length,
              itemBuilder: (context, index) {
                Turma turma = turmas[index];

                return ListTile(
                  title: Text(turma.disciplina),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(turma.codigoDisciplina),
                      Text(turma.curso),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PresencaTurma(turma: turma),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}