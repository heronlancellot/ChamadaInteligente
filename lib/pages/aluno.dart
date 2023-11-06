import 'package:chamadainteligente/models/aluno.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/turma.dart';

class TelaAluno extends StatefulWidget {
  final Aluno usuario;

  TelaAluno({required this.usuario});

  @override
  _TelaAlunoState createState() => _TelaAlunoState();
}

class _TelaAlunoState extends State<TelaAluno> {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  List<Turma> turmas = [];

  @override
  void initState() {
    super.initState();
    _recuperarTurmas();
  }

  void _recuperarTurmas() async {
    final userId = widget.usuario.id;
    final turmasUsuarioSnapshot = await _database.child("users").child(userId).child("turmas").once();

    if (turmasUsuarioSnapshot.snapshot.value != null) {
      final turmasIdsMap = turmasUsuarioSnapshot.snapshot.value as Map<String, dynamic>;
      final turmasIds = turmasIdsMap.keys.toList();

      for (var turmaId in turmasIds) {
        final turmaSnapshot = await _database.child("turmas").child(turmaId).once();

        if (turmaSnapshot.snapshot.value != null) {
          final turmaData = turmaSnapshot.snapshot.value as Map<dynamic, dynamic>;
          final turma = Turma(
            titulo: turmaData["titulo"] ?? "",
            nomeProfessor: turmaData["nomeProfessor"] ?? "",
            codigoDisciplina: turmaData["codigo"] ?? "",
            curso: turmaData["curso"] ?? "",
          );

          setState(() {
            turmas.add(turma);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Turmas'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "Deslogar") {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: "Deslogar",
                  child: Text("Deslogar"),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Usuário logado: ${widget.usuario.email}',
              style: TextStyle(
                fontSize: 16.0,
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
                  title: Text(turma.titulo),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Professor: ${turma.nomeProfessor}"),
                      Text("Código Disciplina: ${turma.codigoDisciplina}"),
                      Text("Curso: ${turma.curso}"),
                    ],
                  ),
                  onTap: () {
                    //
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
