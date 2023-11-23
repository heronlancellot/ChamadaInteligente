import 'package:chamadainteligente/models/turma.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/aluno.dart';

class ListaAlunosDisciplina extends StatefulWidget {
  final Turma turma;

  ListaAlunosDisciplina({required this.turma});

  @override
  _ListaAlunosDisciplinaState createState() => _ListaAlunosDisciplinaState();
}

class _ListaAlunosDisciplinaState extends State<ListaAlunosDisciplina> {
  List<Aluno> alunos = [];

  @override
  void initState() {
    super.initState();
    carregarAlunos();
  }

  Future<void> carregarAlunos() async {
    final alunosSnapshot = await FirebaseDatabase.instance
        .reference()
        .child("turmas")
        .child(widget.turma.codigoDisciplina)
        .child("alunos")
        .once();

    if (alunosSnapshot.snapshot.value != null) {
      final alunosMap = alunosSnapshot.snapshot.value as Map<dynamic, dynamic>;

      setState(() {
        alunos.clear();

        alunosMap.forEach((id, nome) {
          alunos.add(Aluno(id: id, nome: nome, email: '', matricula: ''));
        });
      });
    }
  }

  Future<void> exibirCadastroAlunoDialog() async {
    String email = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cadastrar aluno'),
          content: TextField(
            onChanged: (value) {
              email = value;
            },
            decoration: InputDecoration(labelText: 'E-mail do aluno'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await cadastrarAluno(email);
                Navigator.pop(context);
              },
              child: Text('Cadastrar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> cadastrarAluno(String email) async {
    try {
      final userQuery = await FirebaseDatabase.instance
          .reference()
          .child("users")
          .orderByChild("email")
          .equalTo(email)
          .once();

      final dynamic userData = userQuery.snapshot.value;

      if (userData != null && userData is Map<dynamic, dynamic>) {
        if (userData.isNotEmpty) {
          final userId = userData.keys.first;
          
          if (userData.values.first["nome"] != null) {
            final String nome = userData.values.first["nome"] as String;

            await FirebaseDatabase.instance
                .reference()
                .child("turmas")
                .child(widget.turma.codigoDisciplina)
                .child("alunos")
                .child(userId)
                .set(nome);

            await FirebaseDatabase.instance
                .reference()
                .child("users")
                .child(userId)
                .child("turmas")
                .child(widget.turma.codigoDisciplina)
                .set(widget.turma.titulo);

            carregarAlunos();

            print("Aluno cadastrado com sucesso!");
          } else {
            print("O atributo 'nome' no nó do usuário é nulo ou não existe.");
          }
        } else {
          print("Usuário não encontrado com o email: $email");
        }
      } else {
        print("Dados de usuário inválidos.");
      }
    } catch (error) {
      print("Erro ao cadastrar aluno: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alunos'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String choice) {
              if (choice == 'cadastrarAluno') {
                exibirCadastroAlunoDialog();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'cadastrarAluno',
                  child: Text('Cadastrar aluno'),
                ),
              ];
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: alunos.length,
        itemBuilder: (context, index) {
          Aluno aluno = alunos[index];
          return GestureDetector(
            onLongPress: () {
              mostrarDialogRemover(aluno.id);
            },
            child: ListTile(
              title: Text(aluno.nome),
              onTap: () {
                obterDetalhesAluno(aluno.id, context);
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> mostrarDialogRemover(String alunoId) async {
    bool confirmacao = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remover Aluno'),
          content: Text('Tem certeza de que deseja remover este aluno da disciplina?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (confirmacao == true) {
      setState(() {
        alunos.removeWhere((aluno) => aluno.id == alunoId);
      });

      await FirebaseDatabase.instance
          .reference()
          .child("turmas")
          .child(widget.turma.codigoDisciplina)
          .child("alunos")
          .child(alunoId)
          .remove();

      await FirebaseDatabase.instance
          .reference()
          .child("users")
          .child(alunoId)
          .child("turmas")
          .child(widget.turma.codigoDisciplina)
          .remove();
    }
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
