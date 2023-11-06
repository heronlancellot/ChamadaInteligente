import 'package:chamadainteligente/Widgets/call_status.dart';
import 'package:chamadainteligente/models/aluno.dart';
import 'package:flutter/material.dart';

class TelaAluno extends StatefulWidget {
  final Aluno usuario;

  TelaAluno({required this.usuario});

  @override
  _TelaAlunoState createState() => _TelaAlunoState();
}

class _TelaAlunoState extends State<TelaAluno> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turmas'),
      ),
      body: const Column(
        children: [
          CardCallStatusApp(),
          CardCallStatusApp(),
        ],
      ),
    );
  }
}
