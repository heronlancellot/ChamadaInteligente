import 'package:chamadainteligente/pages/presencaTurma.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/turma.dart';
import '../models/usuario.dart';
import 'detalhesTurma.dart';
import 'novaTurma.dart';

class InicioPage extends StatefulWidget {
  final Usuario usuario;

  InicioPage({required this.usuario});

  @override
  _UsuarioPageState createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<InicioPage> {
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
              if (widget.usuario.tipo == "professor") {
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
              } else {
                return <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: "Deslogar",
                    child: Text("Deslogar"),
                  ),
                ];
              }
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
                    if (widget.usuario.tipo == "professor") {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PresencaTurma(turma: turma),
                        ),
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetalhesTurmaPage(turma: turma),
                        ),
                      );
                    }
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
