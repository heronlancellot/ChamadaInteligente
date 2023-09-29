import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController nomeUsuarioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chamada Inteligente'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Logar no sistema',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: nomeUsuarioController,
                decoration: InputDecoration(
                  labelText: 'Nome de Usuário',
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  /*
                  String nomeUsuario = nomeUsuarioController.text;
                  // Navegar para a tela do professor, passando o nome de usuário como parâmetro
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TelaProfessor(nomeUsuario: nomeUsuario),
                    ),
                  );
                  */
                },
                child: Text('Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}