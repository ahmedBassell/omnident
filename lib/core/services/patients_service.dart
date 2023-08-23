import 'package:omni_dent/core/models/patient.dart';

class PatientsService {
  static List<Patient> patientsArray = [];

  Patient createPatient(String name) {
    int id = _calculateNextId();
    Patient new_patient = Patient.new(id: id, name: name);
    patientsArray.add(new_patient);
    return new_patient;
  }

  int _calculateNextId() {
    return 1;
  }
}
