import 'package:chamadainteligente/models/aluno.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/turma.dart';
import 'alunosDisciplina.dart';
import 'alunosPresentes.dart';

class PresencaTurma extends StatefulWidget {
  final Turma turma;

  PresencaTurma({required this.turma});

  @override
  _PresencaTurmaState createState() => _PresencaTurmaState();
}

class _PresencaTurmaState extends State<PresencaTurma> {
  bool chamadaAtiva = false;
  bool chamadaEncerrada = false;
  List<Aluno> alunos = [];

  @override
  void initState() {
    super.initState();
    verificarChamada();
  }

  Future<void> verificarChamada() async {

    String dataAtual = DateTime.now().toString();
    String dataAteDia = dataAtual.split(' ')[0];

    final chamadaEncerradaSnapshot = await FirebaseDatabase.instance
        .reference()
        .child("presencas")
        .child(widget.turma.codigoDisciplina)
        .child(dataAteDia)
        .child("encerrada")
        .once();

    setState(() {
      chamadaEncerrada = chamadaEncerradaSnapshot.snapshot.value != null;
    });

    final chamadaSnapshot = await FirebaseDatabase.instance
        .reference()
        .child("chamadas")
        .child(widget.turma.codigoDisciplina)
        .once();

    setState(() {
      chamadaAtiva = chamadaSnapshot.snapshot.value != null;
    });

    final presencasSnapshot = await FirebaseDatabase.instance
        .reference()
        .child("presencas")
        .child(widget.turma.codigoDisciplina)
        .child(dataAteDia)
        .child("alunos")
        .once();

    if (presencasSnapshot.snapshot.value != null) {
      final alunosMap = presencasSnapshot.snapshot.value as Map<dynamic, dynamic>;

      alunos.clear();
      alunosMap.forEach((idAluno, dadosAluno) {
        final alunoData = dadosAluno as Map<dynamic, dynamic>;
        setState(() {
          alunos.add(Aluno(
            id: idAluno,
            nome: alunoData['nome'].toString(),
            email: '',
            matricula: '',
          ));
        });
      });
    }
  }

  Future<void> iniciarChamada() async {

    var status = await Permission.location.status;
    if (status.isDenied) {
      mostrarAlertaPermissao();
    } else if (status.isGranted) {

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      String coordenadasLocalizacao = "${position.latitude}° N, ${position.longitude}° W";

      String dataAtual = DateTime.now().toString();
      String dataAteDia = dataAtual.split(' ')[0];

      await FirebaseDatabase.instance
          .reference()
          .child("presencas")
          .child(widget.turma.codigoDisciplina)
          .child(dataAteDia)
          .remove();

      await FirebaseDatabase.instance
          .reference()
          .child("chamadas")
          .child(widget.turma.codigoDisciplina)
          .set({
        "titulo": widget.turma.titulo,
        "dataAtual": dataAtual,
        "coordenadas": coordenadasLocalizacao,
      });

      setState(() {
        chamadaAtiva = true;
        chamadaEncerrada = false;
        alunos = [];
      });

    }

  }

  Future<void> mostrarAlertaPermissao() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permissão de localização necessária'),
          content: Text('Por favor, conceda permissão de localização para continuar.'),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                solicitarPermissao();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> solicitarPermissao() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('Permissão de localização concedida');
    } else {
      print('Permissão de localização negada');
    }
  }

  Future<void> encerrarChamada() async {
    String dataAtual = DateTime.now().toString();
    String dataAteDia = dataAtual.split(' ')[0];

    await FirebaseDatabase.instance
        .reference()
        .child("chamadas")
        .child(widget.turma.codigoDisciplina)
        .remove();

    await FirebaseDatabase.instance
        .reference()
        .child("presencas")
        .child(widget.turma.codigoDisciplina)
        .child(dataAteDia)
        .update({
      "encerrada": true,
    });

    setState(() {
      chamadaAtiva = false;
      chamadaEncerrada = true;
    });
  }

  Future<void> exibirDetalhesAluno(String alunoId, BuildContext context) async {
    final detalhesAlunoSnapshot = await FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(alunoId)
        .once();

    if (detalhesAlunoSnapshot.snapshot.value != null) {
      Map<dynamic, dynamic> detalhesAlunoMap = detalhesAlunoSnapshot.snapshot.value as Map<dynamic, dynamic>;
      String nome = detalhesAlunoMap['nome']?.toString() ?? '';
      String matricula = detalhesAlunoMap['matricula']?.toString() ?? '';
      String curso = detalhesAlunoMap['curso']?.toString() ?? '';
      String email = detalhesAlunoMap['email']?.toString() ?? '';

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Detalhes do aluno'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Nome: $nome'),
                Text('Matrícula: $matricula'),
                Text('Curso: $curso'),
                Text('E-mail: $email'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Fechar'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> exibirHistorico(BuildContext context) async {
    List<String> datas = [];

    final historicoSnapshot = await FirebaseDatabase.instance
        .reference()
        .child("presencas")
        .child(widget.turma.codigoDisciplina)
        .once();

    final historicoMap = historicoSnapshot.snapshot.value as Map<dynamic, dynamic>;

    if (historicoMap != null) {
      datas = historicoMap.keys.cast<String>().toList();
      datas.sort((a, b) => b.compareTo(a));
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Histórico de frequência'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: datas.length,
              itemBuilder: (context, index) {
                String data = datas[index];
                return ListTile(
                  title: Text(data),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListaAlunos(
                          codigoDisciplina: widget.turma.codigoDisciplina,
                          data: data,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.turma.titulo),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String choice) {
              if (choice == 'historico') {
                exibirHistorico(context);
              } else if (choice == 'alunos') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListaAlunosDisciplina(
                      turma: widget.turma,
                    ),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'alunos',
                  child: Text('Alunos'),
                ),
                PopupMenuItem<String>(
                  value: 'historico',
                  child: Text('Histórico de frequência'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              chamadaEncerrada
                  ? 'Chamada encerrada, alunos presentes:'
                  : chamadaAtiva
                  ? 'Alunos presentes:'
                  : 'A chamada não está ativa',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (alunos.isNotEmpty && (chamadaAtiva || chamadaEncerrada))
            Expanded(
              child: ListView.builder(
                itemCount: alunos.length,
                itemBuilder: (context, index) {
                  Aluno aluno = alunos[index];

                  return ListTile(
                    title: Text(aluno.nome),
                    onTap: () {
                      exibirDetalhesAluno(aluno.id, context);
                    },
                  );
                },
              ),
            ),
          if (!chamadaAtiva && !chamadaEncerrada)
            Center(
              child: ElevatedButton(
                onPressed: iniciarChamada,
                child: Text('Iniciar chamada'),
              ),
            ),
          if (chamadaAtiva && !chamadaEncerrada)
            Center(
              child: ElevatedButton(
                onPressed: encerrarChamada,
                child: Text('Encerrar chamada'),
              ),
            ),
        ],
      ),
    );
  }
}
