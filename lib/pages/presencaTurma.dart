import 'package:chamadainteligente/controller/chamadaManager';
import 'package:chamadainteligente/models/usuario.dart';
import 'package:flutter/material.dart';
import '../models/turma.dart';
import 'class_details.dart';

class PresencaTurma extends StatefulWidget {
  final Turma turma;

  PresencaTurma({required this.turma});

  @override
  _PresencaTurmaState createState() => _PresencaTurmaState();
}

class _PresencaTurmaState extends State<PresencaTurma> {
  List<Usuario> alunos = [];
  late ChamadaManager _chamadaManager;

  @override
  void initState() {
    super.initState();
    _chamadaManager = ChamadaManager();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.turma.id),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ClassDetails(turma: widget.turma),
          ),
          Button(),
        ],
      ),
    );
  }

  Widget Button() {
    return ElevatedButton(
      onPressed: () async {
        // await _chamadaManager.criarChamada(widget.turma.id);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
      ),
      child: const Text("Abrir Chamada"),
    );
  }
}
