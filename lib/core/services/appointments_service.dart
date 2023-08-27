import 'package:omni_dent/core/models/appointment.dart';
import 'package:omni_dent/core/models/patient.dart';

class AppointmentsService {
  static List<Appointment> appointmentsArray = [];
  Appointment createAppointment(
      {required name, required DateTime dateTime, required Patient patient}) {
    int id = _calculateNextId();
    Appointment new_appointment = Appointment.new(
        id: id, name: name, dateTime: dateTime, patient: patient);
    appointmentsArray.add(new_appointment);
    return new_appointment;
  }

  int _calculateNextId() {
    return 1;
  }

  List<Appointment> getPatientAppointments(int patientId) {
    return appointmentsArray
        .where((appointment) => appointment.patient.id == patientId)
        .toList();
  }

  List<Appointment> getAppointments() {
    return appointmentsArray;
  }
}
