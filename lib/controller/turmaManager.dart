import 'package:firebase_database/firebase_database.dart';
import '../models/turma.dart';

class TurmaManager {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  TurmaManager();

  Future<List<Turma>> recuperarTurmas(String userId) async {
    List<Turma> turmas = [];

    final turmasUsuarioSnapshot =
        await _database.child("users").child(userId).child("turmas").once();

    if (turmasUsuarioSnapshot.snapshot.value != null) {
      final turmasIdsMap =
          turmasUsuarioSnapshot.snapshot.value as Map<dynamic, dynamic>;
      final turmasIds = turmasIdsMap.keys.cast<String>().toList();

      for (var turmaId in turmasIds) {
        final turmaSnapshot =
            await _database.child("turmas").child(turmaId).once();

        if (turmaSnapshot.snapshot.value != null) {
          final turmaData =
              turmaSnapshot.snapshot.value as Map<dynamic, dynamic>;
          final turma = Turma(
            id: turmaData["titulo"] ?? "",
            nomeProfessor: turmaData["nomeProfessor"] ?? "",
            codigoDisciplina: turmaData["codigo"] ?? "",
            curso: turmaData["curso"] ?? "",
          );

          turmas.add(turma);
        }
      }
    }

    return turmas;
  }
}
