import 'package:omni_dent/core/models/patient.dart';

class PatientsService {
  static List<Patient> patientsArray = [];

  Patient createPatient(
      {required String name, String? phone, String? email, String? notes}) {
    int id = _calculateNextId();
    Patient new_patient = Patient.new(
        id: id, name: name, phone: phone, email: email, notes: notes);
    patientsArray.add(new_patient);
    return new_patient;
  }

  int _calculateNextId() {
    return 1;
  }

  List<Patient> getPatients() {
    return patientsArray;
  }
}
