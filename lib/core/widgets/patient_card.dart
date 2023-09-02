import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/core/models/appointment.dart';
import 'package:omni_dent/core/models/patient.dart';
import 'package:omni_dent/core/services/appointments_service.dart';
import 'package:omni_dent/core/services/patients_service.dart';
import 'package:omni_dent/database/database.dart';

class PatientCard extends StatelessWidget {
  PatientsService get _patientsService => GetIt.I<PatientsService>();
  AppointmentsService get _appointmentsService =>
      GetIt.I<AppointmentsService>();
  final Patient patient;

  PatientCard(this.patient);

  @override
  Widget build(BuildContext context) {
    Appointment? lastAppointment = null;
    // await _appointmentsService.lastAppointment(patient);
    int age = _patientsService.calculateAge(patient);

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(right: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              patient.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            if (age > 0) Text('Age: ${age}'),
            if (patient.phone != null) Text('Phone: ${patient.phone}'),
            if (patient.email != null) Text('Email: ${patient.email}'),
            if (patient.gender != null) Text('Gender: ${patient.gender}'),
            if (lastAppointment != null)
              Text(
                'Last Appointment: ${lastAppointment.dateTimeFrom.day}/${lastAppointment.dateTimeFrom.month}/${lastAppointment.dateTimeFrom.year}',
              ),
          ],
        ),
      ),
    );
  }
}
