import 'package:chamadainteligente/controller/firebaseManager.dart';
import 'package:flutter/material.dart';
import 'pages/login.dart';

void main() async {
  await FirebaseManager.initializeFirebase();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
