import 'package:chamadainteligente/controller/chamadaController.dart';
import 'package:chamadainteligente/controller/userManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/turma.dart';

class StudentPage extends StatefulWidget {
  final Turma turma;

  StudentPage({required this.turma});

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  late ChamadaController _chamadaController;
  final UsuarioManager _usuarioManager = UsuarioManager();

  @override
  void initState() {
    super.initState();
    _chamadaController = ChamadaController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.turma.codigoDisciplina),
      ),
      body: Column(
        children: <Widget>[
          PresenceButton(
            alunoId: _usuarioManager.usuario.nome,
            turmaId: widget.turma.codigoDisciplina,
          ),
        ],
      ),
    );
  }

  Widget PresenceButton({
    required String alunoId,
    required String turmaId,
  }) {
    return ElevatedButton(
      onPressed: () async {
        await _chamadaController.marcarPresenca(alunoId, turmaId);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
      ),
      child: const Text("Marcar presença"),
    );
  }
}
