import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/aluno.dart';

class ListaAlunos extends StatelessWidget {
  final String codigoDisciplina;
  final String data;

  ListaAlunos({required this.codigoDisciplina, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data),
      ),
      body: Center(
        child: FutureBuilder(
          future: obterAlunosPresentes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Erro: ${snapshot.error}');
            } else {
              List<Aluno> alunos = snapshot.data as List<Aluno>;
              return ListView.builder(
                itemCount: alunos.length,
                itemBuilder: (context, index) {
                  Aluno aluno = alunos[index];
                  return ListTile(
                    title: Text(aluno.nome),
                    onTap: () {
                      obterDetalhesAluno(aluno.id, context);
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }


  Future<List<Aluno>> obterAlunosPresentes() async {
    final presencasSnapshot = await FirebaseDatabase.instance
        .reference()
        .child("presencas")
        .child(codigoDisciplina)
        .child(data)
        .child("alunos")
        .once();

    List<Aluno> alunos = [];
    if (presencasSnapshot.snapshot.value != null) {
      Map<dynamic, dynamic> alunosMap = presencasSnapshot.snapshot.value as Map<dynamic, dynamic>;

      alunosMap.forEach((idAluno, dadosAluno) {
        final alunoData = dadosAluno as Map<dynamic, dynamic>;

        alunos.add(Aluno(
          id: idAluno,
          nome: alunoData['nome'].toString(),
          email: '',
          matricula: '',
        ));
      });
    }

    return alunos;
  }

  Future<void> obterDetalhesAluno(String idAluno, BuildContext context) async {
    final detalhesAlunoSnapshot = await FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(idAluno)
        .once();

    if (detalhesAlunoSnapshot.snapshot.value != null) {
      Map<dynamic, dynamic> detalhesAlunoMap = detalhesAlunoSnapshot.snapshot.value as Map<dynamic, dynamic>;
      String nome = detalhesAlunoMap['nome']?.toString() ?? '';
      String matricula = detalhesAlunoMap['matricula']?.toString() ?? '';
      String curso = detalhesAlunoMap['curso']?.toString() ?? '';
      String email = detalhesAlunoMap['email']?.toString() ?? '';

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Detalhes do aluno'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Nome: $nome'),
                Text('Matrícula: $matricula'),
                Text('Curso: $curso'),
                Text('E-mail: $email'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Fechar'),
              ),
            ],
          );
        },
      );
    }
  }
}
