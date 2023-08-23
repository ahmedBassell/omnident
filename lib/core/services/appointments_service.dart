import 'package:omni_dent/core/models/appointment.dart';
import 'package:omni_dent/core/models/patient.dart';

class AppointmentsService {
  Appointment createAppointment(
      String name, DateTime dateTime, Patient patient) {
    int id = _calculateNextId();
    return Appointment.new(
        id: id, name: name, dateTime: dateTime, patient: patient);
  }

  int _calculateNextId() {
    return 1;
  }
}
