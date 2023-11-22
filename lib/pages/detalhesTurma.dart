import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/turma.dart';
import '../models/chamada.dart';
import '../models/usuario.dart';

class DetalhesTurmaPage extends StatefulWidget {
  final Turma turma;
  final Usuario usuario;

  DetalhesTurmaPage({required this.turma, required this.usuario});

  @override
  _DetalhesTurmaPageState createState() => _DetalhesTurmaPageState();
}

class _DetalhesTurmaPageState extends State<DetalhesTurmaPage> {
  bool chamadaAtiva = false;
  bool presencaRegistrada = false;
  Chamada? dadosChamada;

  @override
  void initState() {
    super.initState();
    verificarChamadaAtiva();
    verificarPresencaRegistrada();
  }

  Future<void> verificarChamadaAtiva() async {
    final chamadaSnapshot = await FirebaseDatabase.instance
        .reference()
        .child("chamadas")
        .child(widget.turma.codigoDisciplina)
        .once();

    setState(() {
      chamadaAtiva = chamadaSnapshot.snapshot.value != null;

      if (chamadaAtiva) {
        final chamadaData = chamadaSnapshot.snapshot.value as Map<dynamic, dynamic>;
        dadosChamada = Chamada(
          coordenadas: chamadaData['coordenadas'].toString(),
          titulo: chamadaData['titulo'].toString(),
          data: chamadaData['dataAtual'].toString(),
        );
      }
    });
  }

  Future<void> verificarPresencaRegistrada() async {
    String data = DateTime.now().toLocal().toString().split(' ')[0];

    final presencaSnapshot = await FirebaseDatabase.instance
        .reference()
        .child("presencas")
        .child(widget.turma.codigoDisciplina)
        .child(data)
        .child("alunos")
        .child(widget.usuario.id)
        .once();

    setState(() {
      presencaRegistrada = presencaSnapshot.snapshot.value != null;
    });
  }

  bool areCoordinatesClose(String coord1, String coord2, double maxDistanceMeters) {
    final match1 = RegExp(r'([-+]?\d*\.?\d+)\s*°\s*([EWNS])').allMatches(coord1).toList();
    final match2 = RegExp(r'([-+]?\d*\.?\d+)\s*°\s*([EWNS])').allMatches(coord2).toList();

    final lat1 = double.parse(match1[0][1]!);
    final lon1 = double.parse(match1[1][1]!);
    final lat2 = double.parse(match2[0][1]!);
    final lon2 = double.parse(match2[1][1]!);

    final latDiff = (lat1 - lat2).abs();
    final lonDiff = (lon1 - lon2).abs();

    return latDiff < maxDistanceMeters && lonDiff < maxDistanceMeters;
  }

  Future<void> verificarPresenca(Chamada chamada) async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    String coordenadasAtual = "${position.latitude}° N, ${position.longitude}° W";
    double maxDistanceMeters = 0.00045;
    bool areClose = areCoordinatesClose(coordenadasAtual, chamada.coordenadas, maxDistanceMeters);

    if (areClose) {
      String data = chamada.data.split(' ')[0];
      await FirebaseDatabase.instance
          .reference()
          .child("presencas")
          .child(widget.turma.codigoDisciplina)
          .child(data)
          .child("alunos")
          .child(widget.usuario.id)
          .set({
        "nome": widget.usuario.nome,
      });

      setState(() {
        presencaRegistrada = true;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Presença registrada!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Você não está próximo à sala de aula'),
            content: Text('Para marcar presença, você deve estar próximo à sala de aula.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.turma.titulo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Professor:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              widget.turma.nomeProfessor,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Código da Disciplina:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              widget.turma.codigoDisciplina,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24.0),
            if (chamadaAtiva)
              Center(
                child: Column(
                  children: [
                    Text(
                      presencaRegistrada
                          ? 'Presença já registrada'
                          : 'Chamada ativa',
                      style: TextStyle(
                        fontSize: 20,
                        color: presencaRegistrada ? Colors.green : Colors.red,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    if (!presencaRegistrada)
                      ElevatedButton(
                        onPressed: () {
                          verificarPresenca(dadosChamada!);
                        },
                        child: Text('Marcar presença'),
                      ),
                  ],
                ),
              ),
            if (!chamadaAtiva)
              Text(
                'Chamada não está ativa.',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
