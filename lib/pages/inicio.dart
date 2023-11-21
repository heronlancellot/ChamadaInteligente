import 'package:chamadainteligente/controller/turmaManager.dart';
import 'package:chamadainteligente/controller/userManager.dart';
import 'package:chamadainteligente/pages/professorPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/turma.dart';
import '../models/usuario.dart';
import 'studentPage.dart';
import 'novaTurma.dart';

class InicioPage extends StatefulWidget {
  final Usuario usuario;

  InicioPage({required this.usuario});

  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final TurmaManager _turmaManager = TurmaManager();
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  List<Turma> turmas = [];
  late UsuarioManager _usuarioManager;

  @override
  void initState() {
    super.initState();
    _usuarioManager = UsuarioManager();
    _usuarioManager.setUsuario(widget.usuario);
    _recuperarTurmas();
  }

  void _recuperarTurmas() async {
    List<Turma> turmasRecuperadas =
        await _turmaManager.recuperarTurmas(_usuarioManager.usuario.id);

    setState(() {
      turmas = turmasRecuperadas;
    });
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
                      user: _usuarioManager.usuario,
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
              if (_usuarioManager.usuario.tipo == "professor") {
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Usuário logado: ${_usuarioManager.usuario.email}',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: turmas.length,
              itemBuilder: (context, index) {
                Turma turma = turmas[index];

                return ListTile(
                  title: Text(turma.id),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Professor: ${turma.nomeProfessor}"),
                      Text("Código Disciplina: ${turma.codigoDisciplina}"),
                      Text("Curso: ${turma.curso}"),
                    ],
                  ),
                  onTap: () {
                    if (_usuarioManager.usuario.tipo == "professor") {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfessorPage(turma: turma),
                        ),
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StudentPage(turma: turma),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
