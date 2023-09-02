import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/database/database.dart';

class AppointmentsService {
  // static List<Appointment> appointmentsArray = [];
  OmniDatabase get _db => GetIt.I<OmniDatabase>();
  Appointment createAppointment(
      {required name, required DateTime dateTime, required Patient patient}) {
    int id = _calculateNextId();
    Appointment appointment = Appointment(
        id: id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        patient: patient.id,
        location: 0,
        title: "title",
        dateTimeFrom: dateTime);
    _db.appointments.insertOne(appointment);
    return appointment;
  }

  int _calculateNextId() {
    return 1;
  }

  Future<List<Appointment>> getPatientAppointments(int patientId) async {
    // return appointmentsArray
    //     .where((appointment) => appointment.patient.id == patientId)
    //     .toList();
    return await (_db.appointments.select()
          ..where((a) => a.patient.equals(patientId)))
        .get();
  }

  Future<List<Appointment>> getAppointments() async {
    return await _db.appointments.all().get();
  }
}
