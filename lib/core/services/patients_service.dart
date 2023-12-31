import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/core/models/gender.dart';
import 'package:omni_dent/database/database.dart';

class PatientsService {
  OmniDatabase get _db => GetIt.I<OmniDatabase>();

  // Create
  Future<Patient> createPatient(
      {required String name,
      required Gender gender,
      String? phone,
      String? email,
      String? notes,
      DateTime? birthDate}) async {
    DateTime _defaultBirthDate = DateTime(1990);
    int patientId = await _db.patients.insertOne(PatientsCompanion.insert(
        name: name,
        gender: gender,
        birthDate:
            (birthDate == null ? Value(_defaultBirthDate) : Value(birthDate))));
    return findById(patientId);
  }

  // Read
  Future<Patient> findById(int patientId) async {
    return await (_db.patients.select()
          ..where((tbl) => tbl.id.equals(patientId)))
        .getSingle();
  }

  Future<List<Patient>> getPatients({int limit = 50, int offset = 0}) async {
    List<Patient> patients =
        await (_db.select(_db.patients)..limit(limit, offset: offset)).get();
    return patients;
  }

  Future<List<Patient>> getRecentPatients(
      {int limit = 50, int offset = 0}) async {
    DateTime lower = DateTime.now().add(Duration(days: -1));
    DateTime higher = DateTime.now().add(Duration(days: 1));

    final query = _db.select(_db.patients, distinct: true).join([
      leftOuterJoin(
          _db.appointments, _db.appointments.patient.equalsExp(_db.patients.id),
          useColumns: false),
    ])
      ..where(_db.appointments.dateTimeFrom.isBetweenValues(lower, higher) |
          _db.appointments.dateTimeFrom.isNull());
    query.orderBy([OrderingTerm.asc(_db.appointments.dateTimeFrom)]);
    query.limit(limit, offset: offset);

    return query.map((row) => row.readTable(_db.patients)).get();
  }

  Stream<List<Patient>> watchRecentPatients({int limit = 50, int offset = 0}) {
    DateTime lower = DateTime.now().add(Duration(days: -1));
    DateTime higher = DateTime.now().add(Duration(days: 1));

    final query = _db.select(_db.patients, distinct: true).join([
      leftOuterJoin(
          _db.appointments, _db.appointments.patient.equalsExp(_db.patients.id),
          useColumns: false),
    ])
      ..where(_db.appointments.dateTimeFrom.isBetweenValues(lower, higher) |
          _db.appointments.dateTimeFrom.isNull());
    query.orderBy([OrderingTerm.asc(_db.appointments.dateTimeFrom)]);
    query.limit(limit, offset: offset);

    return query.watch().map((rows) {
      return rows.map((row) => row.readTable(_db.patients)).toList();
    });
  }

  // Update
  Future<Patient> update(
      {required int patientId,
      required String name,
      required gender,
      String? phone,
      String? email,
      DateTime? birthDate}) async {
    DateTime _defaultBirthDate = DateTime(1990);
    await (_db.patients.update()..where((tbl) => tbl.id.equals(patientId)))
        .write(PatientsCompanion(
            name: Value(name),
            email: Value(email),
            gender: Value(gender),
            birthDate: (birthDate == null
                ? Value(_defaultBirthDate)
                : Value(birthDate))));

    return findById(patientId);
  }

  // Delete
  Future<void> delete({
    required int patientId,
  }) async {
    await _db.transaction(() async {
      await (_db.appointments.delete()
            ..where((tbl) => tbl.patient.equals(patientId)))
          .go();
      await (_db.sessionTeeth.delete()
            ..where((tbl) => tbl.patient.equals(patientId)))
          .go();
      await (_db.sessionAttachments.delete()
            ..where((tbl) => tbl.patient.equals(patientId)))
          .go();
      await (_db.sessions.delete()
            ..where((tbl) => tbl.patient.equals(patientId)))
          .go();
      await (_db.patients.delete()..where((tbl) => tbl.id.equals(patientId)))
          .go();
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  int calculateAge(Patient p) {
    final currentDate = DateTime.now();
    int age = currentDate.year - p.birthDate!.year;

    if (currentDate.month < p.birthDate.month ||
        (currentDate.month == p.birthDate.month &&
            currentDate.day < p.birthDate.day)) {
      age--;
    }

    return age;
  }

  Future<int> totalCount() async {
    var countExp = _db.patients.id.count();
    final query = _db.selectOnly(_db.patients)..addColumns([countExp]);
    var result = await query.map((row) => row.read(countExp)).getSingle();
    return result!;
  }

  Future<List<Patient>> searchByQuery(
      {required String query, int limit = 50, int offset = 0}) async {
    final sqlQuery = await (_db.select(_db.patients).join([
      innerJoin(
          _db.sessionTeeth, _db.sessionTeeth.patient.equalsExp(_db.patients.id))
    ])
      ..where(_db.patients.name.contains(query) |
          _db.patients.email.contains(query) |
          _db.sessionTeeth.toothName.contains(query))
      ..limit(limit, offset: offset));
    return sqlQuery.map((row) => row.readTable(_db.patients)).get();
  }
}
