import 'package:chamadainteligente/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/turma.dart';

typedef void TurmaCallback(Turma novaTurma);

class NovaTurmaPage extends StatefulWidget {
  final Usuario user;
  final TurmaCallback onTurmaAdicionada;
  NovaTurmaPage({required this.user, required this.onTurmaAdicionada});

  @override
  _NovaTurmaPageState createState() => _NovaTurmaPageState();
}

class _NovaTurmaPageState extends State<NovaTurmaPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController cursoController = TextEditingController();

  void _adicionarNovaTurma() async {
    final titulo = tituloController.text;
    final codigo = codigoController.text;
    final curso = cursoController.text;

    if (titulo.isNotEmpty && codigo.isNotEmpty && curso.isNotEmpty) {
      final newTurmaRef = _database.child("turmas").child(codigo);

      // salvar a nova turma no nó "turmas"
      final novaTurmaData = {
        "titulo": titulo,
        "codigo": codigo,
        "curso": curso,
        "nomeProfessor": widget.user.nome ?? "",
      };
      await newTurmaRef.set(novaTurmaData);

      // salvar a nova turma no nó "turmas" do usuário professor
      final userTurmasRef = _database.child("users").child(widget.user.id).child("turmas").child(codigo);
      await userTurmasRef.set(titulo);

      widget.onTurmaAdicionada(Turma(
        titulo: titulo,
        codigoDisciplina: codigo,
        curso: curso,
        nomeProfessor: widget.user.nome ?? "",
      ));

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Turma'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: tituloController,
              decoration: InputDecoration(labelText: 'Título da disciplina'),
            ),
            TextFormField(
              controller: codigoController,
              decoration: InputDecoration(labelText: 'Código da disciplina'),
            ),
            TextFormField(
              controller: cursoController,
              decoration: InputDecoration(labelText: 'Curso'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _adicionarNovaTurma,
              child: Text('Adicionar turma'),
            ),
          ],
        ),
      ),
    );
  }
}
