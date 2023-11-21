import 'package:firebase_database/firebase_database.dart';

class ChamadaController {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  String? _chamadaId;
  List<String> _alunosPresentes = [];

  Future<void> criarChamada(String turmaId, String date) async {
    DatabaseReference chamadaRef =
        _database.child("turmas").child(turmaId).child("chamadas");
    _chamadaId = chamadaRef.push().key ?? '';

    await chamadaRef.child(_chamadaId!).set({
      "title": "Título da Chamada",
      "aberta": true,
      "date": date,
      "presenca": " ",
    });
  }

  Future<void> marcarPresenca(String alunoId, String turmaId) async {
    print(alunoId + turmaId + _chamadaId.toString());
    DatabaseReference chamadaRef = _database
        .child("turmas")
        .child(turmaId)
        .child("chamadas")
        .child("-NjjdYYiO-q6gsBl90RC")
        .child("presenca");

    // Recupera o estado da chamada
    DatabaseEvent chamadaEvent = await chamadaRef.once();

    DataSnapshot chamadaSnapshot = chamadaEvent.snapshot;

    _alunosPresentes.add(alunoId);

    // Atualiza a lista de presença no banco de dados
    await chamadaRef.set({
      _alunosPresentes,
    });
  }

  Future<void> fecharChamada(String turmaId) async {
    if (_chamadaId == null) {
      print("Nenhuma chamada aberta.");
      return;
    }

    DatabaseReference chamadaRef =
        _database.child("turmas").child(turmaId).child("chamadas");

    await chamadaRef.child(_chamadaId!).update({
      "aberta": false,
    });

    _chamadaId = null;
    _alunosPresentes = [];
  }
}
