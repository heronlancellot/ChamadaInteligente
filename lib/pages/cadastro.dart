import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../Widgets/CustomInputField.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailUsuarioController = TextEditingController();
  final TextEditingController senhaUsuarioController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  String tipoSelecionado = "Aluno"; // opção padrão

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Crie sua conta agora',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              CustomInputField(label: "Nome de usuário", controller: nomeController, isPassword: false),
              SizedBox(height: 16.0),
              CustomInputField(label: "E-mail", controller: emailUsuarioController, isPassword: false),
              SizedBox(height: 16.0),
              CustomInputField(label: "Senha", controller: senhaUsuarioController, isPassword: true),
              SizedBox(height: 16.0),
              DropdownButton<String>(
                value: tipoSelecionado,
                onChanged: (String? newValue) {
                  setState(() {
                    tipoSelecionado = newValue!;
                  });
                },
                items: <String>['Aluno', 'Professor'].map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  String nome = nomeController.text;
                  String emailUsuario = emailUsuarioController.text.trim().toLowerCase();
                  String senhaUsuario = senhaUsuarioController.text.trim();

                  if (!nome.isEmpty && !emailUsuario.isEmpty && !senhaUsuario.isEmpty) {
                    try {
                      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                        email: emailUsuario,
                        password: senhaUsuario,
                      );

                      if (userCredential.user != null) {
                        final user = userCredential.user!;
                        // enviar e-mail de confirmação
                        await user.sendEmailVerification();
                        user.updateDisplayName(nome);

                        final userData = {
                          "id": user.uid,
                          "nome": nome,
                          "email": user.email,
                          "tipo": tipoSelecionado.toLowerCase(),
                        };
                        await _database.child("users").child(user.uid).set(userData);

                        // redirecionar para a tela de login
                        Navigator.of(context).pop();

                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erro ao cadastrar.'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro de cadastro: $e'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Por favor, preencha todos os campos.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
