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
      ..where(_db.appointments.dateTimeFrom.isBetweenValues(lower, higher));
    query.orderBy([OrderingTerm.asc(_db.appointments.dateTimeFrom)]);
    query.limit(limit, offset: offset);

    return query.map((row) => row.readTable(_db.patients)).get();
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
    await (_db.patients.delete()..where((tbl) => tbl.id.equals(patientId)))
        .go();
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
}
