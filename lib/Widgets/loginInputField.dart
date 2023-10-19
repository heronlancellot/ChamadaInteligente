import 'package:chamadainteligente/Widgets/CustomInputField.dart';
import 'package:chamadainteligente/pages/aluno.dart';
import 'package:chamadainteligente/pages/professor.dart';
import 'package:flutter/material.dart';

class loginInputField extends StatelessWidget {
  final TextEditingController _nomeUsuarioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInputField(
            label: "Nome de Usuário", controller: _nomeUsuarioController),
        const SizedBox(height: 15),
        CustomInputField(label: "Senha", controller: _passwordController),
        const SizedBox(height: 15),
        EntrarBtn(context)
      ],
    );
  }

  Widget EntrarBtn(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        String nomeUsuario = _nomeUsuarioController.text.trim().toLowerCase();
        if (nomeUsuario.startsWith("aluno")) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TelaAluno(),
            ),
          );
        } else if (nomeUsuario == ("professor")) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProfessorPage(nomeUsuario: nomeUsuario),
            ),
          );
        }
      },
      child: Text('Entrar'),
    );
  }
}
