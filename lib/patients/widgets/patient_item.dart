import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/core/services/patients_service.dart';
import 'package:omni_dent/core/widgets/patient_avatar.dart';
import 'package:omni_dent/core/widgets/patient_creation_form.dart';
import 'package:omni_dent/database/database.dart';
import 'package:omni_dent/patients/screens/patient_screen.dart';

class PatientItem extends StatelessWidget {
  PatientsService get _patientsService => GetIt.I<PatientsService>();
  final Patient patient;
  final Function onPatientDelete;

  PatientItem({required this.patient, required this.onPatientDelete});

  @override
  Widget build(BuildContext context) {
    int age = _patientsService.calculateAge(patient);
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
      child: ListTile(
        leading: PatientAvatar(
          displayName: patient.name,
        ),
        title: Text(
          patient.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (patient.phone != null)
              Text(
                patient.phone!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            if (patient.phone != null) SizedBox(height: 4),
            Text(
              '${age} years · ${patient.gender.name}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                // Navigate to the patient details screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientScreen(patient: patient),
                  ),
                );
              },
            ),
            PopupMenuButton<String>(
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'update',
                  child: Text('Update'),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
              onSelected: (value) async {
                if (value == 'update') {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return PatientCreationForm(existingPatient: patient);
                    },
                  ).whenComplete(() {
                    // Navigator.pop(context);
                  });
                } else if (value == 'delete') {
                  await onPatientDelete(patientId: patient.id);
                  // Handle delete action
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
