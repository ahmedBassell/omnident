import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/database/database.dart';

class AppointmentsService {
  OmniDatabase get _db => GetIt.I<OmniDatabase>();
  Future<Appointment> createAppointment(
      {required name,
      required DateTime dateTime,
      required Patient patient}) async {
    int appointmentId = await _db.appointments.insertOne(
        AppointmentsCompanion.insert(
            title: name, patient: patient.id, dateTimeFrom: Value(dateTime)));
    return findById(appointmentId);
  }

  // Read
  Future<Appointment> findById(int appointmentId) async {
    return await (_db.appointments.select()
          ..where((tbl) => tbl.id.equals(appointmentId)))
        .getSingle();
  }

  Future<List<Appointment>> getPatientAppointments(int patientId) async {
    return await (_db.appointments.select()
          ..where((a) => a.patient.equals(patientId)))
        .get();
  }

  Future<List<AppointmentWithPatient>> getAppointments() async {
    final query = _db.select(_db.appointments).join([
      innerJoin(
          _db.patients, _db.patients.id.equalsExp(_db.appointments.patient)),
    ]);
    query.orderBy([OrderingTerm.asc(_db.appointments.dateTimeFrom)]);

    return query
        .map((row) => AppointmentWithPatient(
            row.readTable(_db.appointments), row.readTable(_db.patients)))
        .get();
  }

  Future<List<AppointmentWithPatient>> getTodayAppointments() async {
    final query = _db.select(_db.appointments).join([
      innerJoin(
          _db.patients, _db.patients.id.equalsExp(_db.appointments.patient)),
    ]);
    DateTime todayDateTime =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    ;

    query.where(_db.appointments.dateTimeFrom
        .isBetweenValues(todayDateTime, todayDateTime.add(Duration(days: 1))));
    query.orderBy([OrderingTerm.asc(_db.appointments.dateTimeFrom)]);

    return query
        .map((row) => AppointmentWithPatient(
            row.readTable(_db.appointments), row.readTable(_db.patients)))
        .get();
  }

  Stream<List<AppointmentWithPatient>> watchTodayAppointments() {
    final query = _db.select(_db.appointments).join([
      innerJoin(
          _db.patients, _db.patients.id.equalsExp(_db.appointments.patient)),
    ]);
    DateTime todayDateTime =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    ;

    query.where(_db.appointments.dateTimeFrom
        .isBetweenValues(todayDateTime, todayDateTime.add(Duration(days: 1))));
    query.orderBy([OrderingTerm.asc(_db.appointments.dateTimeFrom)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return AppointmentWithPatient(
          row.readTable(_db.appointments),
          row.readTable(_db.patients),
        );
      }).toList();
    });
  }

  Future<List<AppointmentWithPatient>> getLaterThisWeekAppointments() async {
    final query = _db.select(_db.appointments).join([
      innerJoin(
          _db.patients, _db.patients.id.equalsExp(_db.appointments.patient)),
    ]);
    DateTime tomorrowDateTime =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .add(Duration(days: 1));
    ;

    query.where(_db.appointments.dateTimeFrom.isBetweenValues(
        tomorrowDateTime, tomorrowDateTime.add(Duration(days: 7))));
    query.orderBy([OrderingTerm.asc(_db.appointments.dateTimeFrom)]);

    return query
        .map((row) => AppointmentWithPatient(
            row.readTable(_db.appointments), row.readTable(_db.patients)))
        .get();
  }

  Stream<List<AppointmentWithPatient>> watchLaterThisWeekAppointments() {
    final query = _db.select(_db.appointments).join([
      innerJoin(
          _db.patients, _db.patients.id.equalsExp(_db.appointments.patient)),
    ]);
    DateTime tomorrowDateTime =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .add(Duration(days: 1));
    ;

    query.where(_db.appointments.dateTimeFrom.isBetweenValues(
        tomorrowDateTime, tomorrowDateTime.add(Duration(days: 7))));
    query.orderBy([OrderingTerm.asc(_db.appointments.dateTimeFrom)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return AppointmentWithPatient(
          row.readTable(_db.appointments),
          row.readTable(_db.patients),
        );
      }).toList();
    });
  }

  // Update
  Future<Appointment> update(
      {required int appointmentId,
      required name,
      required DateTime dateTime,
      required Patient patient}) async {
    await (_db.appointments.update()
          ..where((tbl) => tbl.id.equals(appointmentId)))
        .write(AppointmentsCompanion(
            title: Value(name),
            dateTimeFrom: Value(dateTime),
            patient: Value(patient.id)));

    return findById(appointmentId);
  }

  Future<int> todayCount() async {
    var now = DateTime.now();
    DateTime lower = DateTime(now.year, now.month, now.day);
    DateTime higher = DateTime.now().add(Duration(days: 1));
    var countExp = _db.appointments.id.count();
    final query = _db.selectOnly(_db.appointments)..addColumns([countExp]);
    query.where(_db.appointments.dateTimeFrom.isBetweenValues(lower, higher));
    var result = await query.map((row) => row.read(countExp)).getSingle();
    return result!;
  }
}

class AppointmentWithPatient {
  AppointmentWithPatient(this.appointment, this.patient);

  final Appointment appointment;
  final Patient patient;
}
