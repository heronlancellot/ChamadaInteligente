import 'package:flutter/material.dart';
import '../Widgets/loginInputField.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController nomeUsuarioController = TextEditingController();

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
              RegisterTxt()
            ],
          ),
        ),
      ),
    );
  }

  Widget RegisterTxt() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Registrar",
          style: TextStyle(fontSize: 15.0, color: Colors.blue),
        ),
      ],
    );
  }
}
