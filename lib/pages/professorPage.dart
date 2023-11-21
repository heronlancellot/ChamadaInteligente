import 'package:chamadainteligente/controller/chamadaController.dart';
import 'package:chamadainteligente/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/turma.dart';
import 'class_details.dart';

class ProfessorPage extends StatefulWidget {
  final Turma turma;

  ProfessorPage({required this.turma});

  @override
  _ProfessorPageState createState() => _ProfessorPageState();
}

class _ProfessorPageState extends State<ProfessorPage> {
  List<Usuario> alunos = [];
  late ChamadaController _chamadaController;

  @override
  void initState() {
    super.initState();
    _chamadaController = ChamadaController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text(widget.turma.id),
          ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 50),
          Expanded(
            child: ClassDetails(turma: widget.turma),
          ),
          OpenButton(),
          CloseButton()
        ],
      ),
    );
  }

  Widget OpenButton() {
    return ElevatedButton(
      onPressed: () async {
        await _chamadaController.criarChamada(
            widget.turma.codigoDisciplina, GetDate());
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
      ),
      child: const Text("Abrir Chamada"),
    );
  }

  Widget CloseButton() {
    return ElevatedButton(
      onPressed: () async {
        await _chamadaController.fecharChamada(widget.turma.codigoDisciplina);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
      ),
      child: const Text("Fechar Chamada"),
    );
  }

  String GetDate() {
    DateTime date = DateTime.now();
    String dateFormated = DateFormat('dd/MM/yyyy').format(date);
    return dateFormated;
  }
}
