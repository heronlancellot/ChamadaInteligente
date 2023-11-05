import 'package:chamadainteligente/pages/cadastro.dart';
import 'package:flutter/material.dart';
import '../Widgets/loginInputField.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log-In'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Logar no sistema',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              loginInputField(),
              const SizedBox(height: 25),
              InkWell(
                // Adicione a lógica de navegação ao pressionar
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CadastroPage()),
                  );
                },
                child: Text(
                  "Registrar",
                  style: TextStyle(fontSize: 15.0, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
