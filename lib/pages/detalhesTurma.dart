import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/turma.dart';

class DetalhesTurmaPage extends StatelessWidget {
  final Turma turma;

  DetalhesTurmaPage({required this.turma});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(turma.id),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  //
                },
                child: Text('Marcar presença'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
