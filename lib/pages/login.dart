import 'package:chamadainteligente/pages/cadastro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/loginInputField.dart';
import '../models/usuario.dart';
import 'inicio.dart';

class LoginPage extends StatelessWidget {

  void checkUserAuthentication(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tipoUsuario = prefs.getString('tipoUsuario');
    if (tipoUsuario != null) {
      if (!tipoUsuario.isEmpty) {
        if (user != null) {
          final usuario = Usuario(
            id: user.uid,
            nome: user.displayName ?? "",
            email: user.email ?? "",
            matricula: "",
            tipo: tipoUsuario,
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => InicioPage(usuario: usuario),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    checkUserAuthentication(context);
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
