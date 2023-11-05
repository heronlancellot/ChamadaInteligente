import 'package:chamadainteligente/models/aluno.dart';
import 'package:flutter/material.dart';

class TelaAluno extends StatefulWidget {
  final Aluno usuario;

  TelaAluno({required this.usuario});

  @override
  _TelaAlunoState createState() => _TelaAlunoState();
}

class _TelaAlunoState extends State<TelaAluno> {
  List<Disciplina> turmas = [
    Disciplina(nome: 'Gerência de Projeto', codigoDisciplina: 'COD1', presente: false),
    Disciplina(nome: 'Sistemas Operacionais', codigoDisciplina: 'COD2', presente: false),
    Disciplina(nome: 'Redes de Computadores', codigoDisciplina: 'COD3', presente: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Turmas'),
      ),
      body: ListView.builder(
        itemCount: turmas.length,
        itemBuilder: (context, index) {
          Disciplina turma = turmas[index];

          return ListTile(
            title: Text(turma.nome),
            subtitle: Text('Código: ${turma.codigoDisciplina}'),
            trailing: ElevatedButton(
              onPressed: () {
                setState(() {
                  turma.presente = !turma.presente;
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  turma.presente ? Colors.green : Colors.red,
                ),
              ),
              child: Text(turma.presente ? 'Presente' : 'Ausente'),
            ),
          );
        },
      ),
    );
  }
}

class Disciplina {
  final String nome;
  final String codigoDisciplina;
  bool presente;
  Disciplina({required this.nome, required this.codigoDisciplina, required this.presente});
}
