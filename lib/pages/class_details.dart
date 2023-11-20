import 'package:chamadainteligente/models/turma.dart';
import 'package:flutter/material.dart';

class ClassDetails extends StatelessWidget {
  const ClassDetails({Key? key, required this.turma}) : super(key: key);
  final Turma turma;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 600),
        presenceButton(),
        classDetails(),
      ],
    );
  }

  Widget presenceButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
      ),
      child: const Text("Dar Presença"),
    );
  }

  Widget classDetails() {
    return Column(
      children: [
        Text(
          "Disciplina: ${turma.id}",
          style: TextStyle(fontSize: 18),
        ),
        Text(
          "Código da Disciplina: ${turma.codigoDisciplina}",
          style: TextStyle(fontSize: 18),
        ),
        // Text(
        //   "codigo: ${turma.codigo}",
        //   style: TextStyle(fontSize: 18),
        // ),
      ],
    );
  }
}
