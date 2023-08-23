import 'package:omni_dent/core/models/patient.dart';

class PatientsService {
  Patient createPatient(String name) {
    int id = _calculateNextId();
    return Patient.new(id: id, name: name);
  }

  int _calculateNextId() {
    return 1;
  }
}
