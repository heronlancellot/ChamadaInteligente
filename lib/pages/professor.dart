import 'package:chamadainteligente/models/professor.dart';
import 'package:chamadainteligente/pages/presencaTurma.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/turma.dart';
import 'novaTurma.dart';

class ProfessorPage extends StatefulWidget {
  final Professor usuario;

  ProfessorPage({required this.usuario});

  @override
  _ProfessorPageState createState() => _ProfessorPageState();
}

class _ProfessorPageState extends State<ProfessorPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  List<Turma> turmas = [];

  @override
  void initState() {
    super.initState();
    _recuperarTurmasDoFirebase();
  }

  void _recuperarTurmasDoFirebase() async {
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
              if (value == "AdicionarTurma") {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NovaTurmaPage(
                      user: widget.usuario,
                      onTurmaAdicionada: (novaTurma) {
                        setState(() {
                          turmas.add(novaTurma);
                        });
                      },
                    ),
                  ),
                );
              } else if (value == "Deslogar") {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: "AdicionarTurma",
                  child: Text("Adicionar turma"),
                ),
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

