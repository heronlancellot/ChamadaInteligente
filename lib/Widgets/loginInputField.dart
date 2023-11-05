import 'package:chamadainteligente/Widgets/CustomInputField.dart';
import 'package:chamadainteligente/models/professor.dart';
import 'package:chamadainteligente/pages/aluno.dart';
import 'package:chamadainteligente/pages/professor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/aluno.dart';

class loginInputField extends StatelessWidget {
  final TextEditingController _emailUsuarioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInputField(label: "E-mail", controller: _emailUsuarioController, isPassword: false),
        const SizedBox(height: 15),
        CustomInputField(label: "Senha", controller: _passwordController, isPassword: true),
        const SizedBox(height: 15),
        EntrarBtn(context)
      ],
    );
  }

  Widget EntrarBtn(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        String emailUsuario = _emailUsuarioController.text.trim().toLowerCase();
        String senhaUsuario = _passwordController.text.trim().toLowerCase();

        if (!emailUsuario.isEmpty && !senhaUsuario.isEmpty) {
          try {

            UserCredential userCredential = await _auth.signInWithEmailAndPassword(
              email: emailUsuario,
              password: senhaUsuario,
            );

            if (userCredential.user != null) {
              final user = userCredential.user!;
              if (user.emailVerified || 1 == 1) { // não exigir confirmação por enquanto
                String nome = user.displayName ?? "";

                final userDataSnapshot = await _database.child("users").child(user.uid).once();
                if (userDataSnapshot.snapshot.value != null) {

                  final userData = userDataSnapshot.snapshot.value as Map<dynamic, dynamic>;

                  String tipoUsuario = userData["tipo"] ?? "";
                  if (!tipoUsuario.isEmpty) {
                    if (tipoUsuario == "professor") {

                      final usuario = Professor(
                        id: user.uid,
                        nome: nome,
                        email: emailUsuario,
                      );

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfessorPage(usuario: usuario),
                        ),
                      );

                    } else {

                      final usuario = Aluno(
                        id: user.uid,
                        nome: nome,
                        email: emailUsuario,
                        matricula: userData["matricula"] ?? "",
                        presente: false,
                      );

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TelaAluno(usuario: usuario),
                        ),
                      );

                    }
                  }

                } else {
                  Fluttertoast.showToast(
                    msg: 'Usuário inválido',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }

              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Por favor, verifique seu e-mail para confirmar o cadastro.'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erro ao fazer login'),
                  duration: Duration(seconds: 3),
                ),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro de autenticação: $e'),
                duration: Duration(seconds: 3),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Por favor, preencha todos os campos'),
              duration: Duration(seconds: 3),
            ),
          );
        }


      },
      child: Text('Entrar'),
    );
  }
}
