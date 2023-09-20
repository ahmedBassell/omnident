import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/core/models/tooth_entry.dart';
import 'package:omni_dent/core/models/tooth_name.dart';
import 'package:omni_dent/core/models/tooth_state.dart';
import 'package:omni_dent/database/database.dart';
import 'package:omni_dent/database/tables.dart';

class SessionsService {
  OmniDatabase get _db => GetIt.I<OmniDatabase>();

  Future<Session> create(
      {required Patient patient,
      required DateTime dateTimeFrom,
      required String title,
      required String treatment,
      required String symptoms,
      required List<ToothEntry> sessionTeeth}) async {
    int sessionId = 0;
    await _db.transaction(() async {
      // insert new session
      sessionId = await _db.sessions.insertOne(SessionsCompanion.insert(
          patient: patient.id,
          title: title,
          treatment: treatment,
          symptoms: Value(symptoms),
          dateTimeFrom: Value(dateTimeFrom)));
      // insert session teeth in batch
      await _db.batch((batch) {
        batch.insertAll(_db.sessionTeeth, sessionTeeth.map((rowEntry) {
          return SessionTeethCompanion.insert(
            patient: patient.id,
            session: sessionId,
            state: rowEntry.toothState!,
            toothName: rowEntry.toothName!,
          );
        }));
      });
    }).onError((error, stackTrace) {
      print(error.toString());
    });

    return findById(sessionId);
  }

  // Read
  Future<Session> findById(int sessionId) async {
    return await (_db.sessions.select()
          ..where((tbl) => tbl.id.equals(sessionId)))
        .getSingle();
  }

  Future<List<Session>> getSessions({required int patientId}) async {
    return await (_db.sessions.select()
          ..where((s) => s.patient.equals(patientId)))
        .get();
  }

  Future<List<SessionWithTeeth>> getSessionsWithTeeth(
      {required int patientId}) async {
    final res = await (_db.sessionTeeth.select().get());
    print(res);
    final sessionsQuery = _db.select(_db.sessions).join([
      innerJoin(_db.sessionTeeth,
          _db.sessionTeeth.session.equalsExp(_db.sessions.id)),
    ]);
    sessionsQuery.where(_db.sessions.patient.equals(patientId));
    sessionsQuery.orderBy([OrderingTerm.asc(_db.sessions.dateTimeFrom)]);

    final results = await sessionsQuery.map((row) {
      final session = row.readTable(_db.sessions);
      final tooth = row.readTable(_db.sessionTeeth);

      return [session, tooth];
    }).get();
    final groupedData = <Session, List<SessionTooth>>{};

    for (final result in results) {
      final session = result[0] as Session;
      final tooth = result[1] as SessionTooth;

      final list = groupedData.putIfAbsent(session, () => []);
      if (tooth != null) {
        list.add(tooth);
      }
    }

    return [
      for (final entry in groupedData.entries)
        SessionWithTeeth(entry.key, entry.value),
    ];
  }

  //Update
  Future<Session> update(
      {required int sessionId,
      required Patient patient,
      required DateTime dateTimeFrom,
      required String title,
      required String treatment,
      required String symptoms,
      required List<ToothEntry> sessionTeeth}) async {
    await _db.transaction(() async {
      // insert new session
      print(sessionTeeth);
      await (_db.sessions.update()..where((tbl) => tbl.id.equals(sessionId)))
          .write(SessionsCompanion(
              patient: Value(patient.id),
              title: Value(title),
              treatment: Value(treatment),
              symptoms: Value(symptoms),
              dateTimeFrom: Value(dateTimeFrom)));
      // insert session teeth in batch
      await (_db.sessionTeeth.delete()
            ..where((tbl) => tbl.session.equals(sessionId)))
          .go();
      print(sessionId);
      await _db.batch((batch) {
        batch.insertAll(_db.sessionTeeth, sessionTeeth.map((rowEntry) {
          return SessionTeethCompanion.insert(
            patient: patient.id,
            session: sessionId,
            state: rowEntry.toothState!,
            toothName: rowEntry.toothName!,
          );
        }));
      });
    });
    return findById(sessionId);
  }

  // Delete
  Future<void> delete({
    required int sessionId,
  }) async {
    await _db.transaction(() async {
      await (_db.sessionTeeth.delete()
            ..where((tbl) => tbl.session.equals(sessionId)))
          .go();
      int n = await (_db.sessions.delete()
            ..where((tbl) => tbl.id.equals(sessionId)))
          .go();
      print(n);
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }
}

class SessionWithTeeth {
  SessionWithTeeth(this.session, this.teeth);

  final Session session;
  final List<SessionTooth> teeth;
}
